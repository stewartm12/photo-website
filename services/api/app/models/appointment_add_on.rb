class AppointmentAddOn < ApplicationRecord
  belongs_to :appointment

  validates :quantity, :name, :price, presence: true

  def total_price
    quantity * price
  end
end
