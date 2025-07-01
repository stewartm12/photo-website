module Confirmable
  extend ActiveSupport::Concern

  ACCESS_BEFORE_CONFIRMATION_IN_HOURS = 1.hour

  included do
    generates_token_for :user_confirmation, expires_in: ACCESS_BEFORE_CONFIRMATION_IN_HOURS
  end

  def confirm!
    return true if confirmed?
    update!(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    generate_token_for(:user_confirmation)
  end

  def send_confirmation_email
    SendEmailConfirmationJob.perform_later(self)
    update(confirmation_sent_at: Time.current)
  end
end
