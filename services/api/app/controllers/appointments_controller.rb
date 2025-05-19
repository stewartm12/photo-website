class AppointmentsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @appointments = pagy(filtered_appointments)
  end

  def show; end

  def edit; end

  def update; end

  private

  def search_params
    params.permit(:customer_search, :status)
  end

  def filtered_appointments
    appointments = Current.store.appointments.includes(:customer, package: :gallery).joins(:customer)

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
