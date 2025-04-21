class Store < ApplicationRecord
  has_many :store_memberships
  has_many :users, through: :store_memberships

  belongs_to :owner, class_name: 'User'

  validates :name, :domain, :slug, presence: true
  validates :domain, :slug, uniqueness: { case_sensitive: false }
end
