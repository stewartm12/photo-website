class SendPasswordResetEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    PasswordsMailer.reset(user).deliver_now
  end
end
