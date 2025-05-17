require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
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
      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:collection) { create(:collection, gallery: gallery) }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let(:package) { create(:package, gallery: gallery) }
      let!(:appointment) { create(:appointment, package: package, customer: customer, store: store) }
      let(:customer2) { create(:customer, store: store, first_name: 'tester', last_name: 'lastname', email: 'tester@email.com') }
      let!(:appointment2) { create(:appointment, package: package, customer: customer2, store: store, status: 'in_progress') }

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug, id: collection.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates appointments' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@appointments)).to be_present
        expect(controller.instance_variable_get(:@appointments)).to include(appointment)
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(2)
      end

      context 'when searching appointments by customer name or email' do
        it 'filters appointments by name' do
          get :index, params: { store_slug: store.slug, customer_search: 'tester' }

          expect(controller.instance_variable_get(:@appointments)).to include(appointment2)
          expect(controller.instance_variable_get(:@appointments)).not_to include(appointment)
        end

        it 'filters appointments by email' do
          get :index, params: { store_slug: store.slug, customer_search: 'first' }

          expect(controller.instance_variable_get(:@appointments)).to include(appointment)
          expect(controller.instance_variable_get(:@appointments)).not_to include(appointment2)
        end

        context 'when searching by status' do
          it 'filters appointments by status' do
            get :index, params: { store_slug: store.slug, status: 'pending' }

            expect(controller.instance_variable_get(:@appointments)).to include(appointment)
            expect(controller.instance_variable_get(:@appointments)).not_to include(appointment2)
          end
        end
      end
    end
  end

  describe 'GET #show' do
  end

  describe 'GET #edit' do
  end
end
