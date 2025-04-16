class AppointmentMailer < ApplicationMailer
  def new_appointment_email(appointment, customer)
    @appointment = appointment
    @customer = customer

    mail(
      to: @customer.email,
      bcc: ENV['BCC_EMAIL'].split(',').join(','),
      subject: 'Photography Appointment Confirmation'
    )
  end
end
