class Appointment < ApplicationRecord
  belongs_to :customer
  belongs_to :store, counter_cache: true
  has_many :locations, dependent: :destroy
  has_many :appointment_events, dependent: :destroy
  has_many :appointment_add_ons, dependent: :destroy
  has_one :appointment_package, dependent: :destroy, autosave: true
  has_one :invoice

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
    appointment_package.price
  end

  def add_ons_price
    appointment_add_ons.sum(&:total_price)
  end

  private

  def notify_customer
    AppointmentMailer.new_appointment_email(self, customer, store).deliver_later
  end
end
