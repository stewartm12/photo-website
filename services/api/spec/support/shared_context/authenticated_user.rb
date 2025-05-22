RSpec.shared_context 'with authenticated user' do
  let(:user) { create(:user) }
  let(:store) { create(:store, owner: user) }
  let(:session) { create(:session, user: user) }

  before do
    create(:store_membership, store: store, user: user)
    allow(controller).to receive(:resume_session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
  end
end
