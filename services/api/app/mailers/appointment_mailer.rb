class AppointmentMailer < ApplicationMailer
  def new_appointment_email(appointment, customer, store)
    @appointment = appointment
    @customer = customer
    @store = store

    mail(
      to: @customer.email,
      bcc: @store.email,
      from: @store.email,
      subject: 'Photography Appointment Confirmation'
    )
  end
end
