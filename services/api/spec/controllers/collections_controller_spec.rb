require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:store) { create(:store, owner: user) }
    let(:session) { create(:session, user: user) }
    let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
    let(:collection) { create(:collection, gallery: gallery) }

    before do
      allow(controller).to receive(:resume_session).and_return(session)
      allow(Current).to receive(:user).and_return(user)
    end

    it 'returns a successful response' do
      get :show, params: { store_slug: store.slug, id: collection.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
