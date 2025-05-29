class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_one_attached :image

  validates :file_key, presence: true, uniqueness: true
  validate :acceptable_image

  acts_as_list top_of_list: 0

  scope :ordered, -> { order(:position) }

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
end
