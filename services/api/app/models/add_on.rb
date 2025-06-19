class AddOn < ApplicationRecord
  belongs_to :gallery, counter_cache: true

  validates :price, presence: true
  validates :name, presence: true, uniqueness: { scope: :gallery_id }
end
