class Collection < ApplicationRecord
  include PhotoUploadable

  attr_accessor :photos_changed

  has_many :photos, as: :imageable, dependent: :destroy
  belongs_to :gallery, counter_cache: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :gallery_id, message: 'should be unique within the same gallery' }

  after_commit :update_photos_count, on: %i[update]

  private

  def update_photos_count
    return unless photos_changed

    self.class.where(id: id).update_all(photos_count: photos.count)
  end
end
