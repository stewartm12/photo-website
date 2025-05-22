class Appointment < ApplicationRecord
  belongs_to :customer
  belongs_to :package
  belongs_to :store
  has_many :appointment_events
  has_many :appointment_add_ons, dependent: :destroy
  has_many :add_ons, through: :appointment_add_ons
  has_many :locations

  after_create :notify_customer

  accepts_nested_attributes_for :appointment_add_ons

  enum :status, {
    pending: 0,
    confirmed: 1,
    in_progress: 2,
    editing: 3,
    delivered: 4,
    completed: 5,
    cancelled: 6,
    no_show: 7
  }

  def total_price
    package_price + add_ons_price
  end

  def package_price
    package.price
  end

  def add_ons_price
    appointment_add_ons.includes(:add_on).sum(&:total_price)
  end

  private

  def notify_customer
    AppointmentMailer.new_appointment_email(self, customer).deliver_later
  end
end
