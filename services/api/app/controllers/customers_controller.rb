class CustomersController < ApplicationController
  include Pagy::Backend

  before_action :set_customer, only: %i[show edit update]

  def index
    @pagy, @customers = pagy(filtered_customers)
  end

  def show
    @customer_appointments = @customer.appointments
  end

  def new
    @customer = Current.store.customers.new
  end

  def create
    @customer = Current.store.customers.new(customer_params)

    if @customer.save
      @pagy, @customers = pagy(filtered_customers)
      flash.now[:success] = 'Customer created successfully'
    else
      flash.now[:alert] = @customer.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      flash.now[:success] = 'Customer updated successfully'
    else
      flash.now[:alert] = @customer.errors.full_messages.to_sentence
    end
  end

  private

  def search_params
    params.permit(:customer_search)
  end

  def customer_params
    params.expect(customer: %i[first_name last_name email phone_number])
  end

  def set_customer
    @customer = Current.store.customers.find_by(id: params[:id])
    redirect_to store_customers_patj, alert: 'Customer not found' unless @customer
  end

  def filtered_customers
    customers = if search_params[:customer_search].present?
      Current.store.customers.where(
        'first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q',
        q: "%#{search_params[:customer_search]}%"
      )
    else
      Current.store.customers
    end

    customers.order(id: :desc)
  end
end
