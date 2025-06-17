require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe '.invite' do
    let(:user) { create(:user) }
    let(:store) { create(:store) }
    let!(:membership) { create(:store_membership, user: user, store: store) }
    let(:invited_email) { 'invited@email.com' }

    it 'sends an invitation email to the invitee' do
      email = InvitationMailer.invite(user, invited_email, store).deliver_now

      expect(email.to).to eq([invited_email])
      expect(email.subject).to eq("#{user.full_name} invited you to join their store")
    end
  end
end
