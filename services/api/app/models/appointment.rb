class Appointment < ApplicationRecord
  belongs_to :customer
  belongs_to :package
  has_many :appointment_add_ons, dependent: :destroy
  has_many :add_ons, through: :appointment_add_ons
  has_many :locations

  after_create :notify_customer

  private

  def notify_customer
    AppointmentMailer.new_appointment_email(self, customer).deliver_later
  end
end
