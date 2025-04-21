require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  describe "#reset" do
    let(:user) { create(:user) }

    it "sends the email to user to reset password" do
      email = PasswordsMailer.reset(user).deliver_now

      expect(email.subject).to eq('Reset your password')
      expect(email.to).to eq([user.email_address])
    end
  end
end
