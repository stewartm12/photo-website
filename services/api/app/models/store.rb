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

  before_validation :generate_slug, on: :create

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :domain, :slug, presence: true
  validates :domain, :slug, uniqueness: { case_sensitive: false }

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
