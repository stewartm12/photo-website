require 'rails_helper'

RSpec.describe AddOnsController, type: :controller do
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

      it 'assigns a new add-on instance' do
        get :new, params: { store_slug: store.slug, gallery_id: gallery.id }

        expect(controller.instance_variable_get(:@add_on)).to be_a_new(AddOn)
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
          add_on: {
            name: new_addon_name,
            price: 100,
            limited: false
          }
        }
      end

      context 'with invalid parameters' do
        let(:new_addon_name) { nil }

        it 'does not create a new add-on' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(AddOn, :count)

          expect(flash[:alert]).to eq("Name can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:new_addon_name) { 'New Add-On' }

        it 'creates a new add-on' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.to change(AddOn, :count).by(1)

          expect(flash[:success]).to eq('Add-on created successfully')
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
      let!(:add_on) { create(:add_on, gallery: gallery) }

      it 'returns a successfull response' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: add_on.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the add-on' do
        get :edit, params: { store_slug: store.slug, gallery_id: gallery.id, id: add_on.id }

        expect(controller.instance_variable_get(:@add_on)).to eq(add_on)
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
      let!(:add_on) { create(:add_on, gallery: gallery) }

      let(:params) do
        {
          store_slug: store.slug,
          gallery_id: gallery.id,
          id: add_on.id,
          add_on: { price: add_on_price }
        }
      end

      context 'with invalid parameters' do
        let(:add_on_price) { nil }

        it 'does not update the add-on' do
          patch :update, params: params, as: :turbo_stream

          expect(add_on.reload.price).not_to eq(nil)
          expect(flash[:alert]).to eq("Price can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:add_on_price) { 500 }

        it 'does not update the add-on' do
          patch :update, params: params, as: :turbo_stream

          expect(add_on.reload.price).to eq(500)
          expect(flash[:success]).to eq("Add-on updated successfully")
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with authenticated user'

    let(:gallery) { create(:gallery, store: store) }
    let!(:add_on) { create(:add_on, gallery: gallery) }

    it 'destroys the add-on' do
      expect {
        delete :destroy, params: { store_slug: store.slug, gallery_id: gallery.id, id: add_on.id }, as: :turbo_stream
      }.to change(AddOn, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
