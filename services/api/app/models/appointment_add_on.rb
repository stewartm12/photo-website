class AppointmentAddOn < ApplicationRecord
  belongs_to :appointment
  belongs_to :add_on

  validates :quantity, presence: true

  def total_price
    add_on.price * quantity
  end
end
