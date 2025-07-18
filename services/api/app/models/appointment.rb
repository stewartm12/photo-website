class Appointment < ApplicationRecord
  include Eventeable

  belongs_to :customer
  belongs_to :store, counter_cache: true
  has_many :locations, dependent: :destroy
  has_many :appointment_events, dependent: :destroy
  has_many :appointment_add_ons, dependent: :destroy
  has_one :appointment_package, dependent: :destroy, autosave: true
  has_one :invoice

  after_create :notify_customer
  after_create :log_appointment_created_event
  after_update :log_appointment_updated_event

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

  TRACKED_CHANGES = %i[
    status
    preferred_date_time
    deposit
    additional_notes
  ].freeze

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
    SendEmailAppointmentJob.perform_later(self, customer, store)
  end

  def log_appointment_created_event
    message, metadata = if Current.user.present?
      ["#{Current.user.full_name} booked an appointment on behalf of customer.", {}]
    else
      ['Customer booked an appointment online.', { created_by: 'online booking' }]
    end

    log_event(
      :appointment_created,
      message,
      metadata: metadata
    )
  end

  def log_appointment_updated_event
    updated_field(:appointment_updated)
  end

  def generate_change_message(attr, from, to)
    case attr
    when :status
      "Changed status from '#{status_name(from)}' -> '#{status_name(to)}'"
    when :preferred_date_time
      "Changed appointment time from '#{format_time(from)}' -> '#{format_time(to)}'"
    when :deposit
      "Changed deposit from $#{'%.2f' % from} -> $#{'%.2f' % to}"
    when :additional_notes
      "Additional Notes has been updated from '#{from}' -> '#{to}'"
    end
  end

  def status_name(value)
    self.class.statuses.key(value) || value.to_s
  end

  def format_time(value)
    return nil if value.nil?

    value.strftime('%B %-d, %Y at %-l:%M %p %Z')
  end
end
