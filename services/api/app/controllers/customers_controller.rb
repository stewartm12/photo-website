class CustomersController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @customers = pagy(filtered_customers)
  end

  def show; end

  def edit; end

  def update; end

  private

  def search_params
    params.permit(:customer_search)
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
