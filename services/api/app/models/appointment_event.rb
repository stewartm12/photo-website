class AppointmentEvent < ApplicationRecord
  belongs_to :appointment
  belongs_to :user, optional: true

  enum :event_type, {
    appointment_created: 'appointment_created',
    appointment_updated: 'appointment_updated',
    add_on_updated: 'add_on_updated',
    location_added: 'location_added',
    location_updated: 'location_updated',
    invoice_created: 'invoice_created',
    invoice_updated: 'invoice_updated'
  }
end
