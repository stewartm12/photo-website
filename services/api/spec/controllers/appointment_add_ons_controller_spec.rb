require 'rails_helper'

RSpec.describe AppointmentAddOnsController, type: :controller do
  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'store_slug', appointment_id: '1' }
    end

    context 'when use is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let(:gallery)  { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:appointment) { create(:appointment, customer: customer, store: store) }
      let(:add_on1) { create(:add_on, gallery: gallery, price: 5.00) }
      let!(:appointment_add_on1) do
        create(:appointment_add_on,
          appointment: appointment,
          name: add_on1.name,
          price: add_on1.price,
          quantity: 2,
          limited: add_on1.limited
        )
      end

      it 'returns a successfull response' do
        get :edit, params: { store_slug: store.slug, appointment_id: appointment.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns the appointment_add_ons' do
        get :edit, params: { store_slug: store.slug, appointment_id: appointment.id }

        expect(controller.instance_variable_get(:@appointment_add_ons)).to match(a_hash_including(
          appointment_add_on1.id => {
            id: add_on1.id,
            name: add_on1.name,
            price: add_on1.price,
            quantity: appointment_add_on1.quantity,
            limited: add_on1.limited
          }
        ))
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :edit, { store_slug: 'store_slug', appointment_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let(:gallery)  { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:appointment) { create(:appointment, customer: customer, store: store) }
      let(:add_on1) { create(:add_on, gallery: gallery) }
      let(:add_on2) { create(:add_on, gallery: gallery) }
      let!(:add_on3) { create(:add_on, gallery: gallery) }
      let!(:appointment_add_on1) do
        create(:appointment_add_on,
          appointment: appointment,
          name: add_on1.name,
          price: add_on1.price,
          limited: add_on1.limited
        )
      end
      let!(:appointment_add_on2) do
        create(:appointment_add_on,
          appointment: appointment,
          name: add_on2.name,
          price: add_on2.price,
          limited: add_on2.limited
        )
      end

      context 'with invalid parameters' do
        let(:params) do
          {
            store_slug: store.slug,
            appointment_id: appointment.id,
            appointment: {
              appointment_add_ons_attributes: {
                '0' => {
                  add_on_id: nil,
                  quantity: 2
                }
              }
            }
          }
        end

        it 'does not update the appointment add-ons' do
          expect {
            patch :update, params: params, as: :turbo_stream
          }.not_to change(AppointmentAddOn, :count)
          expect(appointment.reload.appointment_add_ons).to match_array([appointment_add_on1, appointment_add_on2])
        end

        it 'rescues and returns an error message' do
          patch :update, params: params, as: :turbo_stream

          expect(flash[:alert]).to eq("Failed to update add-ons: Couldn't find AddOn without an ID")
        end
      end

      context 'with valid parameters' do
        let(:params) do
          {
            store_slug: store.slug,
            appointment_id: appointment.id,
            appointment: {
              appointment_add_ons_attributes: {
                '0' => {
                  add_on_id: add_on3.id,
                  quantity: 2
                }
              }
            }
          }
        end

        it 'updates the appointment add-ons' do
          patch :update, params: params, as: :turbo_stream

          expect(appointment.reload.appointment_add_ons.last.name).to eq(add_on3.name)
          expect(appointment.reload.appointment_add_ons).not_to match_array([appointment_add_on1, appointment_add_on2])
          expect(flash[:success]).to eq('Add-ons updated successfully.')
        end
      end
    end
  end
end
