require 'rails_helper'
require 'zip'

RSpec.describe PhotosController, type: :controller do
  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'store_slug', gallery_id: '1', collection_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:collection) { create(:collection, gallery: gallery) }

      it 'returns a success response' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id, collection_id: collection.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns a new photo' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id, collection_id: collection.id }

        expect(controller.instance_variable_get(:@photo)).to be_a_new(Photo)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', gallery_id: '1', collection_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:collection) { create(:collection, gallery: gallery) }
      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          collection_id: collection.id,
          photo: {
            images: signed_ids
          }
        }
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'store_slug', id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:photo1) { create(:photo, position: 1) }
      let!(:photo2) { create(:photo, position: 2) }

      it 'reorders the photo to the new position' do
        patch :update, params: { store_slug: store.slug, id: photo2.id, position: 1 }

        expect(response).to have_http_status(:no_content)
        expect(photo2.reload.position).to eq(1)
        expect(photo1.reload.position).to eq(2)
      end

      it 'returns 204 no content even if position is the same' do
        patch :update, params: { store_slug: store.slug, id: photo1.id, position: 1 }

        expect(response).to have_http_status(:no_content)
        expect(photo1.reload.position).to eq(1)
      end
    end
  end

  describe 'GET #download' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :download, { store_slug: 'store_slug', gallery_id: '1', collection_id: '1' }
    end
  end

  describe 'DESTROY #bulk_delete' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :delete, :bulk_delete, { store_slug: 'store_slug', gallery_id: '1', collection_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:collection) { create(:collection, gallery: gallery) }
      let!(:photo) { create(:photo, imageable: collection) }
      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          collection_id: collection.id,
          photo_ids: [photo.id]
        }
      end

      it 'successfully deletes all selected photos' do
        delete :bulk_delete, params: params, as: :turbo_stream

        expect(collection.reload.photos.count).to eq(0)
        expect(collection.reload.photos_count).to eq(0)
        expect(flash[:success]).to eq('Photo(s) deleted successfully from collection')
      end
    end
  end
end
