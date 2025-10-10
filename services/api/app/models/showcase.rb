class Showcase < ApplicationRecord
  include PhotoUploadable
  include PhotoIncludable

  attr_accessor :photos_changed

  belongs_to :store
  has_many :photos, as: :imageable, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :store_id }

  after_commit :update_photos_count, on: %i[update]

  after_update :revalidate_frontend_cache

  before_destroy :store_old_name

  after_commit :revalidate_frontend_cache, on: %i[create update destroy]

  private

  def update_photos_count
    return unless photos_changed

    self.class.where(id: id).update_all(photos_count: photos.count)
  end

  def store_old_name
    @old_name = name
  end

  def revalidate_frontend_cache
    name_tag = if destroyed?
                      "gallery:#{@old_slug}"
    elsif previous_changes.key?('slug')
                      "gallery:#{previous_changes['slug'][1]}"
    else name
    end

    FrontendCacheRevalidationJob.perform_later(tags: ["showcase:#{name_tag}"])
  end
end
