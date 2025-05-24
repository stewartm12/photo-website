require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'store_slug', gallery_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns a new package instance' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(controller.instance_variable_get(:@package)).to be_a_new(Package)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', gallery_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          package: {
            name: new_package_name,
            price: 100,
            edited_images: 5,
            outfit_change: false,
            duration: 60,
            popular: true,
            features: ['Feature 1']
          }
        }
      end

      context 'with invalid parameters' do
        let(:new_package_name) { nil }

        it 'does not create a new package' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(Package, :count)

          expect(flash[:alert]).to eq("Name can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:new_package_name) { 'New Package' }

        it 'creates a new package' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.to change(Package, :count).by(1)

          expect(flash[:success]).to eq('Package created successfully')
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'store_slug', gallery_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let!(:package) { create(:package, gallery: gallery) }

      it 'returns a successfull response' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: package.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the package' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: package.id }

        expect(controller.instance_variable_get(:@package)).to eq(package)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'store_slug', gallery_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let!(:package) { create(:package, gallery: gallery, price: 100) }

      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          id: package.id,
          package: { price: package_price }
        }
      end

      context 'with invalid parameters' do
        let(:package_price) { nil }

        it 'does not update the package' do
          patch :update, params: params, as: :turbo_stream

          expect(package.reload.price).not_to eq(nil)
          expect(flash[:alert]).to eq("Price can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:package_price) { 500 }

        it 'does not update the package' do
          patch :update, params: params, as: :turbo_stream

          expect(package.reload.price).to eq(500)
          expect(flash[:success]).to eq("Package updated successfully")
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with authenticated user'

    let(:gallery) { create(:gallery, store: store) }
    let!(:package) { create(:package, gallery: gallery) }

    it 'destroys the package' do
      expect {
        delete :destroy, params: { store_slug: store.slug, gallery_id: gallery.id, id: package.id }, as: :turbo_stream
      }.to change(Package, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
