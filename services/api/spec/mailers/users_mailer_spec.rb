require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  describe "account_confirmation" do
    let(:user) { create(:user) }

    it "sends the email to the newly created user" do
      email = UsersMailer.account_confirmation(user).deliver_now

      expect(email.subject).to eq('Welcome to Pics Cloud! Please confirm your account.')
      expect(email.to).to eq([user.email_address])
    end
  end
end
