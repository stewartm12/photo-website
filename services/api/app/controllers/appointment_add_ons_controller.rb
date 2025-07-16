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
    Appointments::UpdateAddOns.new(
      appointment: appointment,
      add_on_params: app_add_on_params,
      current_user: Current.user
    ).call

    flash.now[:success] = 'Add-ons updated successfully.'
  rescue => e
    flash.now[:alert] = "Failed to update add-ons: #{e.message}"
  end

  private

  def app_add_on_params
    if params[:appointment].present?
      params.expect(appointment: {
        appointment_add_ons_attributes: [%i[add_on_id quantity]]
      }).dig(:appointment_add_ons_attributes) || {}
    else
      {}
    end
  end

  def appointment
    @appointment ||= Current.store.appointments.find_by(id: params[:appointment_id])
  end
end
