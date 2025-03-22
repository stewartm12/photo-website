class Package < ApplicationRecord
  belongs_to :gallery
  has_many :appointments

  validates :name, :price, :gallery, presence: true
end
