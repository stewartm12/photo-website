class Gallery < ApplicationRecord
  include PhotoUploadable

  has_one :photo, as: :imageable, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :photos, through: :collections
  has_many :packages, dependent: :destroy
  has_many :add_ons, dependent: :destroy
  belongs_to :store, counter_cache: true

  accepts_nested_attributes_for :photo

  before_validation :generate_slug, on: :create
  before_save :generate_slug, if: :name_changed?
  before_save :titleize_name, :capitalize_description

  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false, scope: :store_id }

  before_destroy :store_old_slug

  after_commit :revalidate_frontend_cache, on: %i[create update destroy]

  private

  def generate_slug
    self.slug = name&.parameterize
  end

  def titleize_name
    self.name = name&.titleize
  end

  def capitalize_description
    self.description = description&.capitalize
  end

  def store_old_slug
    @old_slug = slug
  end

  def revalidate_frontend_cache
    if previous_changes.key?('name') || previous_changes.key?('description') || previous_changes.key?('slug') || previous_changes.key?('active') || destroyed?
      gallery_tag = if destroyed?
                      "gallery:#{@old_slug}"
      elsif previous_changes.key?('slug')
                      "gallery:#{previous_changes['slug'][1]}"
      end

      tags = %w[navbar services]

      tags << gallery_tag if gallery_tag
      FrontendCacheRevalidationJob.perform_later(tags: tags)
    end
  end
end
