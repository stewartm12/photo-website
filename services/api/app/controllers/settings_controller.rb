class SettingsController < ApplicationController
  include Pagy::Backend

  before_action :set_store

  def show
    @pagy, @store_memberships = pagy(filtered_memberships)
  end

  private

  def filtered_memberships
    store_memberships = @store.store_memberships.includes(:user).joins(:user)

    if params[:name].present?
      store_memberships = store_memberships.where(
        'users.first_name ILIKE :name OR users.last_name ILIKE :name', name: "%#{params[:name]}%"
      )
    end

    store_memberships.order(created_at: :asc)
  end

  def set_store
    @store = Store.find_by(slug: params[:store_slug])
  end
end
