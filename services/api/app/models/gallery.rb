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
  before_save :titleize_name, :capitalize_description

  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false, scope: :store_id }

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end

  def titleize_name
    self.name = name&.titleize
  end

  def capitalize_description
    self.description = description&.capitalize
  end
end
