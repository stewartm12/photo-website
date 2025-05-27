class AppointmentAddOnsController < ApplicationController
  def edit
    @appointment_add_ons = appointment.appointment_add_ons.each_with_object({}) do |addon, hash|
      store_add_on = AddOn.find_by(name: addon.name)

      hash[addon.id] = {
        id: store_add_on&.id,
        name: addon.name,
        price: addon.price,
        quantity: addon.quantity,
        limited: addon.limited
      }
    end
  end

  def update
    Appointment.transaction do
      appointment.appointment_add_ons.destroy_all

      app_add_on_params.values.each do |app_add_on|
        add_on = AddOn.find(app_add_on[:add_on_id])

        appointment.appointment_add_ons.create!(
          name: add_on.name,
          price: add_on.price,
          limited: add_on.limited,
          quantity: app_add_on[:quantity]
        )
      end
    end

    flash.now[:success] = 'Add-ons updated successfully.'
  rescue => e
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
