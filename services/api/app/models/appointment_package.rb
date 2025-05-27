class AppointmentPackage < ApplicationRecord
  belongs_to :appointment

  validates :name, :price, :edited_images, :duration, :features, :gallery_name, presence: true
  validates :outfit_change, inclusion: { in: [true, false] }
end
