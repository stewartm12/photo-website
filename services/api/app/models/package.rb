class Package < ApplicationRecord
  belongs_to :gallery

  validates :name, :price, :gallery, presence: true
end
