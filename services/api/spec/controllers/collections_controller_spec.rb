require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, { store_slug: 'store_slug', gallery_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:baby_collection) { create(:collection, gallery: gallery, name: 'baby collection', shoot_date: Date.today - 1.day) }
      let!(:turtle_collection) { create(:collection, gallery: gallery, name: 'turtle collection', shoot_date: Date.today) }

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates collections' do
        get :index, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(controller.instance_variable_get(:@collections)).to be_present
        expect(controller.instance_variable_get(:@collections)).to match_array([baby_collection, turtle_collection])
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(2)
      end

      context 'whens searching collections by name' do
        it 'filters collections by name' do
          get :index, params: { store_slug: store.slug, gallery_id: gallery.id, name: 'baby' }

          expect(controller.instance_variable_get(:@collections)).to include(baby_collection)
          expect(controller.instance_variable_get(:@collections)).not_to include(turtle_collection)
        end
      end

      context 'when sorting collections by name' do
        it 'sorts collections by name' do
          get :index, params: { store_slug: store.slug, gallery_id: gallery.id, sort: 'name', order: 'asc' }

          expect(controller.instance_variable_get(:@collections)).to eq([baby_collection, turtle_collection])
        end
      end

      context 'when sorting collections by shoot_date' do
        it 'sorts collections by their shoot_date' do
          get :index, params: { store_slug: store.slug, gallery_id: gallery.id, sort: 'shoot_date', order: 'desc' }

          expect(controller.instance_variable_get(:@collections)).to eq([turtle_collection, baby_collection])
        end
      end
    end
  end

  describe 'GET #show' do
    include_context 'with authenticated user'

    let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
    let(:collection) { create(:collection, gallery: gallery) }

    it 'returns a successful response' do
      get :show, params: { store_slug: store.slug, gallery_id: gallery.id, id: collection.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'store_slug', gallery_id: 'gallery_id' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns @collection' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(controller.instance_variable_get(:@collection)).to be_a_new(Collection)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', gallery_id: 'gallery_id' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          collection: {
            name: name,
            shoot_date: Date.today
          }
        }
      end

      context 'with invalid parameters' do
        let(:name) { '' }

        it 'does not create a new collection' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change { Collection.count }

          expect(flash[:alert]).to include("Name can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:name) { 'New Baby Collections' }

        it 'creates a new collection' do
          expect {
            post :create, params: params
          }.to change { Collection.count }.by(1)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'store_slug', gallery_id: 'gallery_id', id: 'collection_id' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:collection) { create(:collection, gallery: gallery) }

      it 'returns a successful response' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: collection.id }

        expect(response).to have_http_status(:ok)
      end

      it 'correctly assign @collection' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: collection.id }

        expect(controller.instance_variable_get(:@collection)).to eq(collection)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'store_slug', gallery_id: 'gallery_id', id: 'collection_id' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:collection) { create(:collection, gallery: gallery) }

      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          id: collection.id,
          collection: {
            name: name,
            shoot_date: Date.today
          }
        }
      end

      context 'with invalid parameters' do
        let(:name) { '' }

        it 'does not update the collection' do
          patch :update, params: params, as: :turbo_stream

          expect(flash[:alert]).to include("Name can't be blank")
          expect(collection.reload.name).not_to eq(name)
        end
      end

      context 'with valid parameters' do
        let(:name) { 'Update Collection Name' }

        it 'updates the collection' do
          patch :update, params: params, as: :turbo_stream

          expect(flash[:success]).to include('Collection updated successfully.')
          expect(collection.reload.name).to eq(name)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :delete, :destroy, { store_slug: 'store_slug', gallery_id: 'gallery_id', id: 'collection_id' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:collection) { create(:collection, gallery: gallery) }

      it 'destroys the collection' do
        expect {
          delete :destroy, params: { store_slug: store.slug, gallery_id: gallery.id, id: collection.id }, as: :turbo_stream
        }.to change(Collection, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
