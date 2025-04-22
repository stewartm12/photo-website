# Preview all emails at http://localhost:3001/rails/mailers/users_mailer
class UsersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3001/rails/mailers/users_mailer/account_confirmation
  def account_confirmation
    UsersMailer.account_confirmation(User.first)
  end
end
