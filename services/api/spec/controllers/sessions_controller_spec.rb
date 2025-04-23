require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    context 'when user is not authenticated' do
      it 'returns a successful response' do
        get :new

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores path' do
        get :new

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores path' do
        post :create

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user, email_address: 'test@example.com', password: 'password123') }
      let(:params) do
        {
          email_address: user.email_address,
          password: 'password123'
        }
      end

      context 'with valid credentials' do
        before { post :create, params: params }

        it 'redirects to the intended page or dashboard' do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(stores_path)
        end

        it 'creates a new session' do
          expect(Session.count).to eq(1)
          expect(Session.last.user).to eq(user)
        end
      end

      context 'with invalid credentials' do
        it 'redirects to login page' do
          post :create, params: { email_address: '', password: '' }, as: :turbo_stream

          expect(flash[:alert]).to eq('Email or password is incorrect.')
        end
      end

      context 'with unconfirmed email' do
        before { user.update(confirmed_at: nil) }

        it 'redirects to login page' do
          post :create, params: params, as: :turbo_stream

          expect(flash[:alert]).to eq('Please confirm your email address before signing in.')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        delete :destroy

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before do
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:session).and_return(session)
      end

      it 'destroys the session' do
        delete :destroy

        expect(Session.count).to eq(0)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
