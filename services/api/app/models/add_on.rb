class AddOn < ApplicationRecord
  belongs_to :gallery

  validates :gallery, :name, :price, presence: true
end
