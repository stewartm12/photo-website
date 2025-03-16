class Showcase < ApplicationRecord
  has_many :photos, as: :imageable

  validates :name, presence: true, uniqueness: true
end
