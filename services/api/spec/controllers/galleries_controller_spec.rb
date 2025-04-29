require 'rails_helper'

RSpec.describe GalleriesController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let(:session) { create(:session, user: user) }
      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      before do
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates galleries' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@galleries)).to be_present
        expect(controller.instance_variable_get(:@galleries)).to include(gallery)
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(1)
      end

      context 'when searching galleries by name' do
        let(:empty_gallery) { create(:gallery, store: store, name: 'empty gallery', slug: 'empty-gallery') }
        let(:full_gallery) { create(:gallery, store: store, name: 'full gallery', slug: 'full-gallery') }

        it 'filters galleries by name' do
          get :index, params: { store_slug: store.slug, search: 'empty' }

          expect(controller.instance_variable_get(:@galleries)).to include(empty_gallery)
          expect(controller.instance_variable_get(:@galleries)).not_to include(full_gallery)
        end
      end

      context 'when searching galleries by status' do
        let(:active_gallery) { create(:gallery, store: store, name: 'active gallery', slug: 'active-gallery', active: true) }
        let(:inactive_gallery) { create(:gallery, store: store, name: 'inactive gallery', slug: 'inactive-gallery', active: false) }

        it 'filters galleries by status' do
          get :index, params: { store_slug: store.slug, active: true }

          expect(controller.instance_variable_get(:@galleries)).to include(active_gallery)
          expect(controller.instance_variable_get(:@galleries)).not_to include(inactive_gallery)
        end
      end

      context 'when sorting galleries' do
        let!(:gallery_1) { create(:gallery, store: store, name: 'first gallery', updated_at: 2.days.ago) }
        let!(:gallery_2) { create(:gallery, store: store, name: 'second gallery', updated_at: 1.day.ago) }

        it 'sorts galleries by name in ascending order' do
          get :index, params: { store_slug: store.slug, sort: 'name', order: 'asc' }

          expect(controller.instance_variable_get(:@galleries)).to eq([gallery_1, gallery, gallery_2])
        end

        it 'sorts galleries by updated_at in descending order' do
          get :index, params: { store_slug: store.slug, sort: 'updated_at', order: 'desc' }

          expect(controller.instance_variable_get(:@galleries)).to eq([gallery, gallery_2, gallery_1])
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:store) { create(:store, owner: user) }
    let(:session) { create(:session, user: user) }
    let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

    before do
      allow(controller).to receive(:resume_session).and_return(session)
      allow(Current).to receive(:user).and_return(user)
    end

    it 'returns a successful response' do
      get :show, params: { store_slug: store.slug, id: gallery.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Destroy #destroy' do
    let(:user) { create(:user) }
    let(:store) { create(:store, owner: user) }
    let(:session) { create(:session, user: user) }
    let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

    before do
      allow(controller).to receive(:resume_session).and_return(session)
      allow(Current).to receive(:user).and_return(user)
    end

    it 'destroys the gallery' do
      expect {
        delete :destroy, params: { store_slug: store.slug, id: gallery.id }, as: :turbo_stream
      }.to change(Gallery, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
