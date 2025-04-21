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

      before { allow(controller).to receive(:resume_session).and_return(session) }

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
end
