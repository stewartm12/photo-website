class AppointmentAddOn < ApplicationRecord
  belongs_to :appointment
  belongs_to :add_on

  validates :quantity, presence: true
end
