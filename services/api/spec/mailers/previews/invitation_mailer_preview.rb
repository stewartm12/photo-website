# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer_mailer
class InvitationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3001/rails/mailers/invitation_mailer/invite
  def invite
    user = User.first
    InvitationMailer.invite(user, 'new-user@email.com', user.stores.first)
  end
end
