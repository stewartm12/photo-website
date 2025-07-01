require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  describe 'GET #new' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        get :new

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      it 'returns a successful response' do
        get :new

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        get :new

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      context 'with valid confirmation token' do
        let(:user) { create(:user, confirmed_at: nil) }

        it 'confirms the user' do
          get :show, params: { token: user.generate_confirmation_token }

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_session_path)
          expect(user.reload.confirmed_at).not_to be_nil
          expect(flash[:notice]).to eq('Your account has been confirmed!')
        end
      end

      context 'with invalid confirmation token' do
        it 'redirects to the sign up page' do
          get :show, params: { token: 'invalid-token' }

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_registration_path)
          expect(flash[:alert]).to eq('Invalid or expired confirmation link')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        get :new

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user) }

      context 'with an invalid email address' do
        it 'should redirect to the sign up page' do
          post :create, params: { email_address: 'invalid-email@test.com' }

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_registration_path)
          expect(flash[:alert]).to eq('Email address not found')
        end
      end

      context 'when user already confirmed' do
        it 'should redirect to the sign in page' do
          post :create, params: { email_address: user.email_address }

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_session_path)
          expect(flash[:notice]).to eq('Account already confirmed. Please sign in')
        end
      end
    end
  end
end
