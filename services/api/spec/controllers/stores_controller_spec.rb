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
      let(:package) { create(:package, gallery: gallery) }
      let!(:appointment) { create(:appointment, package: package, customer: customer, store: store) }
      let!(:old_appointment) { create(:appointment, package: package, customer: customer, store: store, status: 'completed') }

      # before do
      #   create(:store_membership, user: user, store: store)
      #   allow(controller).to receive(:resume_session).and_return(session)
      #   allow(Current).to receive(:user).and_return(user)
      #   allow(Current).to receive(:store).and_return(store)
      # end

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
              domain: 'test1.com'
            }
          }
        end

        it 'creates a new store' do
          expect {
            post :create, params: params
          }.to change(Store, :count).by(1)
        end

        it 'creates a new store membership' do
          expect {
            post :create, params: params
          }.to change(StoreMembership, :count).by(1)
        end

        it 'redirects to the stores index' do
          post :create, params: params

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(stores_path)
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
end
