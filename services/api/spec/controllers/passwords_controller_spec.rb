require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
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

  describe 'POST #create' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        post :create, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user) }
      let(:params) do
        {
          email_address: user.email_address
        }
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        post :create, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user) }

      context 'with a valid token' do
        let(:params) do
          {
            token: user.password_reset_token
          }
        end

        it 'returns a successful response' do
          get :edit, params: params

          expect(response).to have_http_status(:ok)
        end

        it 'assigns @user' do
          get :edit, params: params

          expect(controller.instance_variable_get(:@user)).to eq(user)
        end
      end

      context 'with invalid token' do
        let(:params) do
          {
            token: 'invalid_token'
          }
        end

        before do
          allow(User).to receive(:find_by_password_reset_token!)
            .and_raise(ActiveSupport::MessageVerifier::InvalidSignature)
        end

        it 'redirects to the reset password page' do
          patch :update, params: params

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_password_path)
          expect(flash[:alert]).to eq('Password reset link is invalid or has expired.')
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

      before { allow(controller).to receive(:resume_session).and_return(session) }

      it 'redirects to the stores page' do
        patch :update, params: {}

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stores_path)
      end
    end

    context 'when user is not authenticated' do
      let(:user) { create(:user) }

      context 'with valid token' do
        let(:params) do
          {
            password: 'Password123!',
            password_confirmation: 'Password123!',
            token: user.password_reset_token
          }
        end

        context 'with matching passwords' do
          it 'assigns @user' do
            get :edit, params: params

            expect(controller.instance_variable_get(:@user)).to eq(user)
          end

          it 'successfully updates the password' do
            patch :update, params: params

            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(new_session_path)
            expect(flash[:notice]).to eq('Password has been reset.')
          end
        end

        context 'with non-matching passwords' do
          before { params[:password_confirmation] = 'different_password' }

          it 'does not update the password' do
            patch :update, params: params, as: :turbo_stream

            expect(flash[:alert]).to eq('Passwords do not match.')
          end
        end
      end

      context 'with invalid token' do
        let(:params) do
          {
            token: 'invalid_token'
          }
        end

        before do
          allow(User).to receive(:find_by_password_reset_token!)
            .and_raise(ActiveSupport::MessageVerifier::InvalidSignature)
        end

        it 'redirects to the reset password page' do
          patch :update, params: params

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_password_path)
          expect(flash[:alert]).to eq('Password reset link is invalid or has expired.')
        end
      end
    end
  end
end
