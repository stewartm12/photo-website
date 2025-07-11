class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :success

  before_action :set_current_store_from_slug

  around_action :set_time_zone

  def redirect_signed_in_user
    return unless authenticated?

    redirect_back(fallback_location: stores_path)
  end

  private

  def set_current_store_from_slug
    return unless params[:store_slug]

    store = Current.user.stores.find_by!(slug: params[:store_slug])
    Current.store = store
  end

  def set_time_zone(&block)
    Time.use_zone(Current.store&.time_zone || 'UTC', &block)
  end
end
