class UsersMailer < ApplicationMailer
  def account_confirmation(user)
    @user = user
    mail to: user.email_address, subject: 'Welcome to Pics Cloud! Please confirm your account.'
  end
end
