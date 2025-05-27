require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, { store_slug: 'store_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let!(:appointment) { create(:appointment, customer: customer, store: store) }
      let(:customer2) { create(:customer, store: store, first_name: 'tester', last_name: 'lastname', email: 'tester@email.com') }
      let!(:appointment2) { create(:appointment, customer: customer2, store: store, status: 'in_progress') }

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates appointments' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@appointments)).to be_present
        expect(controller.instance_variable_get(:@appointments)).to include(appointment)
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(2)
      end

      context 'when searching appointments by customer name or email' do
        it 'filters appointments by name' do
          get :index, params: { store_slug: store.slug, customer_search: 'tester' }

          expect(controller.instance_variable_get(:@appointments)).to include(appointment2)
          expect(controller.instance_variable_get(:@appointments)).not_to include(appointment)
        end

        it 'filters appointments by email' do
          get :index, params: { store_slug: store.slug, customer_search: 'first' }

          expect(controller.instance_variable_get(:@appointments)).to include(appointment)
          expect(controller.instance_variable_get(:@appointments)).not_to include(appointment2)
        end

        context 'when searching by status' do
          it 'filters appointments by status' do
            get :index, params: { store_slug: store.slug, status: 'pending' }

            expect(controller.instance_variable_get(:@appointments)).to include(appointment)
            expect(controller.instance_variable_get(:@appointments)).not_to include(appointment2)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { store_slug: 'store_slug', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let!(:appointment) { create(:appointment, customer: customer, store: store) }

      it 'returns a successfull response' do
        get :show, params: { store_slug: store.slug, id: appointment.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the appointment' do
        get :show, params: { store_slug: store.slug, id: appointment.id }

        expect(controller.instance_variable_get(:@appointment)).to eq(appointment)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'random-store', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let!(:appointment) { create(:appointment, customer: customer, store: store) }

      it 'returns a successfull response' do
        get :edit, params: { store_slug: store.slug, id: appointment.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the appointment' do
        get :edit, params: { store_slug: store.slug, id: appointment.id }

        expect(controller.instance_variable_get(:@appointment)).to eq(appointment)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'random-store', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:gallery) { create(:gallery, store: store) }
      let(:customer) { create(:customer, store: store, first_name: 'john', last_name: 'bravo', email: 'first@email.com') }
      let!(:appointment) { create(:appointment, customer: customer, store: store, additional_notes: 'Boo') }

      context 'when params are invalid' do
        let(:params) do
          {
            store_slug: store.slug,
            id: appointment.id,
            appointment: { preferred_date_time: '' }
          }
        end

        before do
          allow_any_instance_of(Appointment).to receive(:update).and_return(false)
          allow_any_instance_of(Appointment).to receive_message_chain(:errors, :full_messages).and_return(['Something went wrong'])
        end

        it 'returns an error message' do
          patch :update, params: params, as: :turbo_stream

          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash[:alert]).to eq('Something went wrong')
        end
      end

      context 'when params are valid' do
        let(:params) do
          {
            store_slug: store.slug,
            id: appointment.id,
            form_type: form_type,
            appointment: nested_params
          }
        end

        context 'when form type is quick_cancel' do
          let(:form_type) { 'quick_cancel' }
          let(:nested_params) { { status: 'cancelled' } }

          it 'cancels the appointment' do
            patch :update, params: params, as: :turbo_stream

            expect(response).to have_http_status(:ok)
            expect(appointment.reload.status).to eq('cancelled')
            expect(flash[:success]).to eq('Appointment successfully cancelled.')
          end
        end

        context 'when form type is not quick_cancel' do
          let(:form_type) { '' }
          let(:nested_params) { { additional_notes: 'This is an addition note' } }

          it 'updates the appointment' do
            patch :update, params: params, as: :turbo_stream

            expect(response).to have_http_status(:ok)
            expect(appointment.reload.additional_notes).to eq('This is an addition note')
            expect(appointment.reload.additional_notes).not_to eq('Boo')
            expect(flash[:success]).to eq('Appointment successfully updated.')
          end
        end
      end
    end
  end
end
