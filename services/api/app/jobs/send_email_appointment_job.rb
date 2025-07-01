class SendEmailAppointmentJob < ApplicationJob
  queue_as :default

  def perform(appt, customer, store)
    AppointmentMailer.new_appointment_email(appt, customer, store).deliver_now
  end
end
