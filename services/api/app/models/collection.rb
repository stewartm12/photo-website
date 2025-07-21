class Collection < ApplicationRecord
  include PhotoUploadable
  include PhotoIncludable

  attr_accessor :photos_changed

  has_many :photos, as: :imageable, dependent: :destroy
  has_many :user_downloads, dependent: :destroy
  belongs_to :gallery, counter_cache: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :gallery_id, message: 'should be unique within the same gallery' }

  before_create :capitalize_name
  after_commit :update_photos_count, on: %i[update]

  private

  def update_photos_count
    return unless photos_changed

    self.class.where(id: id).update_all(photos_count: photos.count)
  end

  def capitalize_name
    self.name = self.name&.titleize
  end
end
