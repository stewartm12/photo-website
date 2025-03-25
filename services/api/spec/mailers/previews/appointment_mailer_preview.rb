class AppointmentMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3001/rails/mailers/appointment_mailer/new_appointment_email
  def new_appointment_email
    appointment = Appointment.last

    if appointment.present?
      AppointmentMailer.new_appointment_email(appointment, appointment.customer)
    else
      nil
    end
  end
end
