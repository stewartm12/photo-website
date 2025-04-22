class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def redirect_signed_in_user
    return unless authenticated?

    redirect_back(fallback_location: stores_path)
  end
end
