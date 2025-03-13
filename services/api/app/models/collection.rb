class Collection < ApplicationRecord
  has_many :photos, as: :imageable, dependent: :destroy
  belongs_to :gallery

  validates :name, presence: true
  validates :name, uniqueness: { scope: :gallery_id, message: 'should be unique within the same gallery' }
end
