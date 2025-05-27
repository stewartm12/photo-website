require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { store_slug: 'store_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the store variable' do
        get :show, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@store)).to eq(store)
      end
    end
  end
end
