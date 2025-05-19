class Collection < ApplicationRecord
  has_many :photos, as: :imageable, dependent: :destroy
  belongs_to :gallery, counter_cache: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :gallery_id, message: 'should be unique within the same gallery' }
end
