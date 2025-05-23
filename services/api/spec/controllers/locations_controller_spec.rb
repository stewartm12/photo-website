require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'store_slug', appointment_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { create(:appointment, package: package, customer: customer, store: store) }

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug, appointment_id: appointment.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns a new location instance' do
        get :new, params: { store_slug: store.slug, appointment_id: appointment.id }

        expect(controller.instance_variable_get(:@location)).to be_a_new(Location)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', appointment_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { create(:appointment, package: package, customer: customer, store: store) }

      let(:params) do
        {
          store_slug: store.slug,
          appointment_id: appointment.id,
          location: { address: address }
        }
      end

      context 'with invalid parameters' do
        let(:address) { nil }

        it 'does not create a new location for that appointment' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(Location, :count)

          expect(flash[:alert]).to eq("Address can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:address) { '123 Main St, CityVille' }

        it 'creates a new location attached to the appointment' do
          expect {
              post :create, params: { store_slug: store.slug, appointment_id: appointment.id, location: { address: '123 Main St' } }, as: :turbo_stream
          }.to change(Location, :count).by(1)

          expect(flash[:success]).to eq('Location created successfully.')
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'store_slug', appointment_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { create(:appointment, package: package, customer: customer, store: store) }
      let!(:location) { create(:location, appointment: appointment) }

      it 'returns a successfull response' do
        get :edit, params: { store_slug: store.slug, appointment_id: appointment.id, id: location.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the location' do
        get :edit, params: { store_slug: store.slug, appointment_id: appointment.id, id: location.id }

        expect(controller.instance_variable_get(:@location)).to eq(location)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :update, { store_slug: 'store_slug', appointment_id: '1', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { create(:appointment, package: package, customer: customer, store: store) }
      let!(:location) { create(:location, appointment: appointment) }

      let(:params) do
        {
          store_slug: store.slug,
          appointment_id: appointment.id,
          id: location.id,
          location: {
            address: address
          }
        }
      end

      context 'with invalid parameters' do
        let(:address) { nil }

        it 'does not update the location' do
          patch :update, params: params, as: :turbo_stream

          expect(location.reload.address).not_to eq(nil)
          expect(flash[:alert]).to eq("Address can't be blank")
        end
      end

      context 'with valid parameters' do
        let(:address) { '123 Main St, CityVille' }

        it 'updates the location' do
          patch :update, params: params, as: :turbo_stream

          expect(location.reload.address).to eq(address)
          expect(flash[:success]).to eq('Location updated successfully.')
        end
      end
    end
  end
end
