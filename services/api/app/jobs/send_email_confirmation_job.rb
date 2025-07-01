class SendEmailConfirmationJob < ApplicationJob
  queue_as :default

  def perform(klass)
    UsersMailer.account_confirmation(klass).deliver_now
  end
end
