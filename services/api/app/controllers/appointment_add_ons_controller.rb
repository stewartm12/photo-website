class AppointmentAddOnsController < ApplicationController
  def edit
    @appointment_add_ons = appointment.appointment_add_ons.includes(:add_on)
  end

  def update
    Appointment.transaction do
      appointment.appointment_add_ons.destroy_all

      app_add_on_params.values.each do |app_add_on|
        appointment.appointment_add_ons.create!(
          add_on_id: app_add_on[:add_on_id],
          quantity: app_add_on[:quantity]
        )
      end
    end

    flash.now[:success] = 'Add-ons updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "Failed to update add-ons: #{e.message}"
  end

  private

  def app_add_on_params
    params.expect(appointment: {
      appointment_add_ons_attributes: [%i[add_on_id quantity]]
    }).dig(:appointment_add_ons_attributes) || {}
  end

  def appointment
    @appointment ||= Current.store.appointments.find_by(id: params[:appointment_id])
  end
end
