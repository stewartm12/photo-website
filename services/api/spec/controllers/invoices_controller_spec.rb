require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', appointment_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let(:appointment) { create(:appointment, customer: customer, store: store) }
      let!(:appointment_package) { create(:appointment_package, appointment: appointment) }
      let(:params) do
        {
          store_slug: store.slug,
          appointment_id: appointment.id
        }
      end

      context 'with invalid parameters' do
        let(:bad_invoice) { build(:invoice, appointment: appointment) }

        before do
          allow(bad_invoice).to receive(:persisted?).and_return(false)
          allow(bad_invoice).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return('Something went wrong')
          allow(AppointmentInvoiceGenerator).to receive(:new).and_return(double(call: bad_invoice))
        end

        it 'does not create an invoice for that appointment' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change(Invoice, :count)
          expect(flash[:alert]).to eq('Something went wrong')
        end
      end

      context 'with valid parameters' do
        it 'creates an invoice for that appointment' do
          expect {
            post :create, params: params, as: :turbo_stream
        }.to change(Invoice, :count).by(1)
          expect(flash[:success]).to eq('Invoice created succesfully')
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'store_slug', appointment_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let(:appointment) { create(:appointment, customer: customer, store: store) }
      let!(:invoice) { create(:invoice, appointment: appointment) }
      let(:params) do
        {
          store_slug: store.slug,
          appointment_id: appointment.id,
          invoice: { status: invoice_status }
        }
      end

      context 'with invalid parameters' do
        let(:invoice_status) { 'invalid_status' }

        it 'does not update the invoice status' do
          expect {
            patch :update, params: params, as: :turbo_stream
          }.not_to change { invoice.reload.status }
          expect(flash[:alert]).to eq('Status is not included in the list')
        end
      end

      context 'with valid parameters' do
        let(:invoice_status) { 'paid' }

        it 'updates the invoice' do
          expect {
            patch :update, params: params, as: :turbo_stream
        }.to change { invoice.reload.status }.to('paid')
        end
      end
    end
  end

  describe 'GET #download' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :download, { store_slug: 'store_slug', appointment_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:customer) { create(:customer, store: store) }
      let(:appointment) { create(:appointment, customer: customer, store: store) }
      let!(:invoice) { create(:invoice, appointment: appointment) }

      before do
        allow(InvoicePdfRenderer).to receive(:new).with(invoice).and_return(double(render: '%PDF content'))
      end

      it 'downloads the invoice PDF' do
        get :download, params: { store_slug: store.slug, appointment_id: appointment.id }

        expect(response).to have_http_status(:ok)
        expect(response.headers['Content-Type']).to include('application/pdf')
        expect(response.body).to include('%PDF')
      end
    end
  end
end
