class PasswordsController < ApplicationController
  allow_unauthenticated_access

  before_action :redirect_signed_in_user
  before_action :set_user_by_token, only: %i[ edit update ]


  def new; end

  def create
    if user = User.find_by(email_address: params[:email_address])
      SendPasswordResetEmailJob.perform_later(user)
    end

    redirect_to new_session_path, notice: 'Password reset instructions sent (if user with that email address exists).'
  end

  def edit; end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: 'Password has been reset.'
    else
      flash.now[:alert] = 'Passwords do not match.'
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: 'Password reset link is invalid or has expired.'
    end
end
