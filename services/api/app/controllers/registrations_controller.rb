class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  before_action :redirect_signed_in_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path, notice: 'Account created successfully. Please check your email to confirm your account.'
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: %i[first_name last_name email_address password password_confirmation])
  end
end
