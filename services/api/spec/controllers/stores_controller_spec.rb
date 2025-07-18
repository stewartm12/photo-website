require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, {}
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:store_2) { create(:store) }

      before { create(:store_membership, user: user, store: store_2) }

      it 'returns a successful response' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it 'assigns @stores' do
        get :index

        expect(controller.instance_variable_get(:@stores)).to match_array([store, store_2])
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { store_slug: 'store_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:collection) { create(:collection, gallery: gallery) }
      let!(:appointment) { create(:appointment, customer: customer, store: store) }
      let!(:old_appointment) { create(:appointment, customer: customer, store: store, status: 'completed') }

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'grabs all the total for galleries, collections, appointments, customers and photos' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@total_galleries)).to eq(1)
        expect(controller.instance_variable_get(:@total_collections)).to eq(1)
        expect(controller.instance_variable_get(:@total_appointments)).to eq(2)
        expect(controller.instance_variable_get(:@total_customers)).to eq(1)
        expect(controller.instance_variable_get(:@total_photos)).to eq(0)
      end

      it 'grabs the recent galleries' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@recent_galleries)).to match_array([gallery])
      end

      it 'grabs the upcoming appointments' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@upcoming_appointments)).to match_array([appointment])
      end

      it 'grabs the newest customers' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@newest_customers)).to match_array([customer])
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, {}
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, {}
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      context 'when store is valid' do
        let(:params) do
          {
            store: {
              name: 'Test 1',
              domain: 'test1.com',
              email: 'tester@email.com',
              photo: { image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test.jpg") }
            }
          }
        end

        it 'creates a new store' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.to change(Store, :count).by(1)
        end

        it 'creates a new store membership' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.to change(StoreMembership, :count).by(1)
        end

        it 'creates a photo association' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.to change(Photo, :count).by(1)
        end
      end

      context 'when store is invalid' do
        let(:params) do
          { store: { name: 'test 2', domain: '' } }
        end

        before do
          allow_any_instance_of(Store).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(store))
        end

        it 'does not create a new store' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(Store, :count)
        end

        it 'does not create a new store membership' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(StoreMembership, :count)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'some_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'returns a successful response' do
        get :edit, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'some_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'
      let!(:photo) { create(:photo, imageable: store) }

      let(:params) do
        {
          store_slug: store.slug,
          store: {
            email: email,
            photo: { image: image_file }
          }
        }
      end

      context 'with invalid parameters' do
        let(:email) { 'wrong-email.com' }
        let(:image_file) { nil }

        it 'does not update the store' do
          patch :update, params: params, as: :turbo_stream

          expect(store.reload.email).not_to eq(email)
          expect(flash[:alert]).to include('Email is invalid')
        end
      end

      context 'with valid parameters' do
        let(:email) { 'good-email@email.com' }
        let(:image_file) { nil }

        context 'when photo is not provided' do

          it 'updates the store successfully' do
            patch :update, params: params, as: :turbo_stream

            expect(store.reload.email).to eq(email)
            expect(flash[:success]).to include('Store updated successfully.')
          end
        end

        context 'when photo is provided' do
          let(:image_file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test2.jpg") }

          it 'updates the photo association' do
            patch :update, params: params, as: :turbo_stream

            expect(store.reload.photo.image.filename.to_s).to eq('test2.jpg')
            expect(flash[:success]).to include('Store updated successfully.')
          end
        end
      end
    end
  end
end
