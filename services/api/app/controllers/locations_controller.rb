class LocationsController < ApplicationController
  before_action :set_location, only: %i[edit update]

  def new
    @location = appointment.locations.new
  end

  def create
    @location = appointment.locations.new(location_params)

    if @location.save
      flash.now[:success] = 'Location created successfully.'
    else
      flash.now[:alert] = @location.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @location.update(location_params)
      flash.now[:success] = 'Location updated successfully.'
    else
      flash.now[:alert] = @location.errors.full_messages.to_sentence
    end
  end

  private

  def location_params
    params.expect(location: %i[address note])
  end

  def set_location
    @location = appointment.locations.find_by(id: params[:id])
    redirect_to store_appointment_path(Current.store, appointment), alert: 'Location not found.' unless @location
  end

  def appointment
    @appointment ||= Current.store.appointments.find_by(id: params[:appointment_id])
  end
end
