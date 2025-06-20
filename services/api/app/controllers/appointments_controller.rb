class AppointmentsController < ApplicationController
  include Pagy::Backend

  before_action :set_appointment, only: %i[edit update]

  def index
    @pagy, @appointments = pagy(filtered_appointments)
  end

  def show
    @appointment = Current.store.appointments.find_by(id: params[:id])
  end

  def new
    @appointment = Current.store.appointments.new
    @packages_and_add_ons = Current.store.galleries.includes(:packages, :add_ons).map do |gallery|
      {
        id: gallery.id,
        name: gallery.name,
        packages: gallery.packages.map { |p| { id: p.id, name: p.name, price: p.price.to_s } },
        add_ons: gallery.add_ons.map { |a| { id: a.id, name: a.name, price: a.price.to_s } }
      }
    end
  end

  def create
    customer = Current.store.customers.find_by(email: create_params[:customer_email])

    if customer.nil?
      flash.now[:alert] = 'Customer not found. Please create a customer first.' and return
    end

    if create_params[:package_id].nil?
      flash.now[:alert] = 'Package is required.' and return
    end

    begin
      @appointment = schedule_appointment(customer)

      @pagy, @appointments = pagy(filtered_appointments)
      flash.now[:success] = 'Appointment successfully created.'
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    message = params[:form_type] == 'quick_cancel' ? 'Appointment successfully cancelled.' : 'Appointment successfully updated.'

    if @appointment.update(update_params)
      @appointment.invoice.update(deposit: update_params[:deposit]) if @appointment.invoice
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

  def create_params
    params.expect(appointment: %i[customer_email preferred_date_time additional_notes status deposit package_id add_on_id])
  end

  def update_params
    params.expect(appointment: %i[status deposit preferred_date_time additional_notes])
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

  def schedule_appointment(customer)
    ScheduleAppointment.new(store: Current.store, user: Current.user).call(
        customer: customer,
        package_id: create_params[:package_id],
        add_on_ids: [create_params[:add_on_id]].compact,
        preferred_date_time: create_params[:preferred_date_time],
        additional_notes: create_params[:additional_notes],
        status: create_params[:status],
        deposit: create_params[:deposit],
        metadata: { created_by: Current.user.full_name }
      )
  end
end
