require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:store) { create(:store) }
      let(:store_2) { create(:store) }

      before do
        create(:store_membership, user: user, store: store)
        create(:store_membership, user: user, store: store_2)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

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
      it 'redirects to the login page' do
        get :index

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:store) { create(:store) }
      let(:customer) { create(:customer, store: store) }
      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:collection) { create(:collection, gallery: gallery) }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { create(:appointment, package: package, customer: customer, store: store) }

      before do
        create(:store_membership, user: user, store: store)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns all @ variables' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@store)).to eq(store)
        expect(controller.instance_variable_get(:@galleries)).to match_array([gallery])
        expect(controller.instance_variable_get(:@collections)).to match_array([collection])
        expect(controller.instance_variable_get(:@appointments)).to match_array([appointment])
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:store) { create(:store) }
      let(:user) { create(:user) }

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:store) { create(:store) }
      let(:user) { create(:user) }

      before do
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

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
