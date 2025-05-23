class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: 'Try again later.' }

  before_action :redirect_signed_in_user, only: %i[new create]

  def new; end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    return flash.now[:alert] = 'Email or password is incorrect.' unless user
    return flash.now[:alert] = 'Please confirm your email address before signing in.' unless user.confirmed?

    start_new_session_for user
    redirect_to after_authentication_path
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: 'You have been signed out.'
  end
end
