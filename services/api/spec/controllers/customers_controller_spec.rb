require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, { store_slug: 'store_slug' }
    end

    describe 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:customer1) { create(:customer, first_name: 'john', last_name: 'doe', email: 'johndoe@email.com', store: store) }
      let!(:customer2) { create(:customer, first_name: 'bob', last_name: 'builder', email: 'bobbuilder@email.com', store: store) }
      let!(:customer3) { create(:customer, first_name: 'eric', last_name: 'grace', email: 'tester@email.com', store: store) }

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates customers' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@customers)).to be_present
        expect(controller.instance_variable_get(:@customers)).to match_array([customer1, customer2, customer3])
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(3)
      end

      context 'when searching customers by name or email' do
        it 'filters customers by name' do
          get :index, params: { store_slug: store.slug, customer_search: 'john' }

          expect(controller.instance_variable_get(:@customers)).to include(customer1)
          expect(controller.instance_variable_get(:@customers)).not_to include(customer2, customer3)
        end

        it 'filters customers by email' do
          get :index, params: { store_slug: store.slug, customer_search: 'tester' }

          expect(controller.instance_variable_get(:@customers)).to include(customer3)
          expect(controller.instance_variable_get(:@customers)).not_to include(customer2, customer1)
        end
      end
    end
  end

  describe 'GET #show' do
  end

  describe 'GET #edit' do
  end

  describe 'PATCH #update' do
  end
end
