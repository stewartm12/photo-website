require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'without authentication' do
      it 'returns a successful response' do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with authentication' do
      before do
        allow(controller).to receive(:authenticated?).and_return(true)
      end

      it 'redirects to the stores path' do
        get :index

        expect(response).to redirect_to(stores_path)
      end
    end
  end
end
