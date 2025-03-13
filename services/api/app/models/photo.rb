class Photo < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :file_key, presence: true, uniqueness: true

  before_save -> { self.file_key = file_key.downcase if file_key.present? }
end
