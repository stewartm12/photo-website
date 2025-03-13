class Gallery < ApplicationRecord
  has_one :photo, as: :imageable, dependent: :destroy
  has_many :collections, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
