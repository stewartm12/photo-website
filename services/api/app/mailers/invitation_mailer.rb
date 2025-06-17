class InvitationMailer < ApplicationMailer
  def invite(user, invited_email, store)
    @user = user
    @invited_email = invited_email
    @store = store

    mail(
      to: invited_email,
      subject: "#{user.full_name} invited you to join their store"
    )
  end
end
