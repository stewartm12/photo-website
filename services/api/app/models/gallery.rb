class Gallery < ApplicationRecord
  has_one :photo, as: :imageable, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :photos, through: :collections
  has_many :packages, dependent: :destroy
  has_many :add_ons, dependent: :destroy
  belongs_to :store

  validates :name, :slug, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name&.parameterize if name.present?
  end
end
