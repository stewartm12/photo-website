class SendEmailInvitationJob < ApplicationJob
  queue_as :default

  def perform(user, email, store)
    InvitationMailer.invite(user, email, store).deliver_now
  end
end
