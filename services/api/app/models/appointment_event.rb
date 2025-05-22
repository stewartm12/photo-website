class AppointmentEvent < ApplicationRecord
  belongs_to :appointment
  belongs_to :user, optional: true

  enum :event_type, {
    appointment_created: 'appointment_created',
    status_changed: 'status_changed',
    appointment_rescheduled: 'appointment_rescheduled',
    add_on_added: 'add_on_added',
    add_on_removed: 'add_on_removed',
    location_added: 'location_added',
    location_removed: 'location_removed',
    location_updated: 'location_updated',
    note_updated: 'note_updated',
    customer_updated: 'customer_updated',
    package_changed: 'package_changed'
  }
end
