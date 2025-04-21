require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
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
      let(:params) do
        { user: {
          first_name: 'John',
          last_name: 'Doe',
          email_address: 'john@gmail.com',
          password: 'password123',
          password_confirmation: 'password123'
        } }
      end

      it 'builds a new user with permitted parameters' do
        post :create, params: params

        expect(controller.instance_variable_get(:@user).first_name).to eq('John')
        expect(controller.instance_variable_get(:@user).last_name).to eq('Doe')
        expect(controller.instance_variable_get(:@user).email_address).to eq('john@gmail.com')
      end

      context 'with valid parameters' do
        it 'creates a new user' do
          expect {
            post :create, params: params
          }.to change { User.count }.by(1)

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(new_session_path)
          expect(flash[:notice]).to include('Account created successfully. Please check your email to confirm your account.')
        end

        context 'with invalid parameters' do
          before { params[:user][:email_address] = nil }

          it 'does not create a new user' do
            expect {
              post :create, params: params
            }.not_to change { User.count }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(flash[:alert]).to include("Email address can't be blank")
          end
        end
      end
    end
  end
end
