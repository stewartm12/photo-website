class Store < ApplicationRecord
  has_many :store_memberships
  has_many :users, through: :store_memberships
  has_many :galleries
  has_many :collections, through: :galleries
  has_many :appointments
  has_many :customers

  belongs_to :owner, class_name: 'User'

  before_validation :generate_slug, on: :create

  validates :name, :domain, :slug, presence: true
  validates :domain, :slug, uniqueness: { case_sensitive: false }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
