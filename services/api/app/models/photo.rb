class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_one_attached :image, dependent: :purge_later

  validates :file_key, presence: true, uniqueness: { scope: %i[imageable_type imageable_id] }
  validate :acceptable_image

  acts_as_list top_of_list: 0

  scope :ordered, -> { order(:position) }

  before_destroy :store_old_imageable

  after_commit :revalidate_frontend_cache, on: %i[create update]

  ACCEPTABLE_IMAGE_TYPES = %w[
    image/jpeg
    image/png
    image/jpg
    image/webp
    image/avif
  ].freeze

  private

  def acceptable_image
    return unless image.attached?

    unless ACCEPTABLE_IMAGE_TYPES.include?(image.content_type)
      errors.add(:image, 'must be a JPEG, PNG, WEBP, or AVIF')
    end

    if image.byte_size > 10.megabytes
      errors.add(:image, 'is too big (max 10MB)')
    end
  end

  def store_old_imageable
    @old_type = imageable_type
    @old_imageable = imageable
  end

  def revalidate_frontend_cache
    if destroyed?
      tags = @old_type == 'Showcase' ? ["showcase:#{@old_imageable.name}"] : [@old_type.downcase.pluralize]
    else
      tags = imageable_type == 'Showcase' ? ["showcase:#{imageable.name}"] : [imageable_type.downcase.pluralize]
    end

    FrontendCacheRevalidationJob.perform_later(tags: tags)
  end
end
