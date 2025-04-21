class WelcomeController < ApplicationController
  allow_unauthenticated_access
  before_action :redirect_signed_in_user

  def index; end
end
