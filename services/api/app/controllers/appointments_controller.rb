class AppointmentsController < ApplicationController
  include Pagy::Backend

  before_action :set_appointment, only: %i[edit update]

  def index
    @pagy, @appointments = pagy(filtered_appointments)
  end

  def show
    @appointment = Current.store.appointments.find_by(id: params[:id])
  end

  def edit; end

  def update
    message = params[:form_type] == 'quick_cancel' ? 'Appointment successfully cancelled.' : 'Appointment successfully updated.'

    if @appointment.update(appointment_params)
      flash.now[:success] = message
    else
      flash.now[:alert] = @appointment.errors.full_messages.to_sentence
      render :update, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.permit(:customer_search, :status)
  end

  def appointment_params
    params.expect(appointment: %i[status preferred_date_time additional_notes])
  end

  def set_appointment
    @appointment = Current.store.appointments.find_by(id: params[:id])
    redirect_to store_appointment_path(Current.store, @appointment), alert: 'Appointment not found.' unless @appointment
  end

  def filtered_appointments
    appointments = Current.store.appointments.includes(:customer, :appointment_package).joins(:customer)

    if search_params[:customer_search].present?
      appointments = appointments.where(
        'customers.first_name ILIKE :q OR customers.last_name ILIKE :q OR customers.email ILIKE :q',
        q: "%#{search_params[:customer_search]}%"
      )
    end

    if search_params[:status].present?
      appointments = appointments.where(status: search_params[:status])
    end

    appointments.order(id: :desc)
  end
end
