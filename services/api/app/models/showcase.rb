class Showcase < ApplicationRecord
  include PhotoUploadable
  include PhotoIncludable

  attr_accessor :photos_changed

  belongs_to :store
  has_many :photos, as: :imageable, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :store_id }

  after_commit :update_photos_count, on: %i[update]

  private

  def update_photos_count
    return unless photos_changed

    self.class.where(id: id).update_all(photos_count: photos.count)
  end
end
