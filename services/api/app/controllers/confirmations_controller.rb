class ConfirmationsController < ApplicationController
  allow_unauthenticated_access

  before_action :redirect_signed_in_user

  def new; end

  def show
    user = User.find_by_token_for(:user_confirmation, params[:token])

    if user.present? && user.confirm!
      redirect_to new_session_path, notice: 'Your account has been confirmed!'
    else
      redirect_to new_registration_path, alert: 'Invalid or expired confirmation link'
    end
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    return redirect_to new_registration_path, alert: 'Email address not found' unless user
    return redirect_to new_session_path, notice: 'Account already confirmed. Please sign in' if user.confirmed?

    user.send_confirmation_email
    redirect_to new_session_path, notice: 'Confirmation email resent'
  end
end
