class Store < ApplicationRecord
  include PhotoUploadable

  has_many :store_memberships
  has_many :users, through: :store_memberships
  has_many :galleries
  has_many :packages, through: :galleries
  has_many :add_ons, through: :galleries
  has_many :collections, through: :galleries
  has_many :appointments
  has_many :customers
  has_many :showcases
  has_one :photo, as: :imageable, dependent: :destroy

  belongs_to :owner, class_name: 'User'

  before_create :capitalize_names

  before_validation :generate_slug, on: :create

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :domain, :slug, presence: true
  validates :domain, :slug, uniqueness: { case_sensitive: false }

  TIME_ZONES = [
    'Pacific Time (US & Canada)',
    'Mountain Time (US & Canada)',
    'Central Time (US & Canada)',
    'Eastern Time (US & Canada)',
    'UTC'
  ].freeze

  validates :time_zone, inclusion: { in: TIME_ZONES, message: '%{value} is not an accepted time zone as of right now.' }

  def to_param
    slug
  end

  def revenue
    appointments
     .joins(:invoice)
     .where(invoices: { status: 'paid' })
     .sum('invoices.subtotal')
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end

  def capitalize_names
    self.name = self.name&.titleize
  end
end
