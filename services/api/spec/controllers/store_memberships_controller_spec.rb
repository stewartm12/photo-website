require 'rails_helper'

RSpec.describe StoreMembershipsController, type: :controller do
  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { store_slug: 'some-store' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:user_inviter) { user }
      let(:invited_user) { create(:user) }
      let(:params) do
        {
          token: user_inviter.generate_invitation_token,
          store_slug: store.slug
        }
      end

      context 'with invalid parameters' do
        context 'with invalid token' do
          before { params[:token] = 'invalid-token' }

          it 'redirects to stores path with an alert' do
            get :show, params: params

            expect(response).to redirect_to(stores_path)
            expect(flash[:alert]).to eq('Invalid or expired confirmation link')
          end
        end

        context 'with non-existent store' do
          before { params[:store_slug] = 'non-existent-store' }

          it 'redirects to stores path with an alert' do
            get :show, params: params

            expect(response).to redirect_to(stores_path)
            expect(flash[:alert]).to eq('Invalid or expired confirmation link')
          end
        end

        context 'when user is already a member of the store' do
          before { create(:store_membership, user: invited_user, store: store) }

          it 'redirects to stores path with an alert' do
            get :show, params: params

            expect(response).to redirect_to(stores_path)
            expect(flash[:alert]).to eq('User is already a member of this store')
          end
        end
      end

      context 'with valid parameters' do
        before { allow(Current).to receive(:user).and_return(invited_user) }

        it 'creates a store membership' do
          expect {
            get :show, params: params
          }.to change(StoreMembership, :count).by(1)

          expect(response).to redirect_to(stores_path)
          expect(flash[:notice]).to eq("You have successfully joined #{store.name}!")
        end
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'some-store' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      it 'renders the new template' do
        get :new, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'some-store' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:invited_user) { create(:user) }

      it 'sends an invitation email' do
        expect(InvitationMailer).to deliver_later(:invite)

        post :create, params: { email: invited_user.email_address, store_slug: store.slug }, as: :turbo_stream

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq('Invitation email sent successfully!')
      end
    end
  end
end
