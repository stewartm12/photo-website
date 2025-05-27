class AddOn < ApplicationRecord
  belongs_to :gallery, counter_cache: true

  validates :name, :price, presence: true
end
