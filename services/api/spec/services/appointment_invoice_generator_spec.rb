require 'rails_helper'

RSpec.describe AppointmentInvoiceGenerator do
  let(:store) { create(:store) }
  let(:customer) { create(:customer, store: store) }
  let(:appointment) { create(:appointment, customer: customer, store: store, deposit: 50.0) }
  let(:gallery) { create(:gallery, store: store) }
  let(:package) { create(:package, price: 200.0, name: 'Standard') }
  let(:add_on) { create(:add_on, gallery: gallery) }
  let!(:app_package) { create(:appointment_package, price: 200.0, name: package.name, appointment: appointment) }
  let!(:app_add_on) { create(:appointment_add_on, appointment: appointment, name: add_on.name, quantity: 2, price: add_on.price) }

  describe '#call' do
    subject(:generated_invoice) { described_class.new(store, appointment).call }

    context 'when no invoice exists' do
      it 'creates a new invoice' do
        expect { generated_invoice }.to change { Invoice.count }.by(1)
      end

      it 'assigns the correct values to the invoice' do
        invoice = generated_invoice
        expect(invoice.appointment).to eq(appointment)
        expect(invoice.subtotal).to eq(appointment.total_price)
        expect(invoice.tax).to eq(0)
        expect(invoice.deposit).to eq(appointment.deposit)
        expect(invoice.total).to eq(appointment.total_price)
      end

      it 'creates line items for the package and add-ons' do
        invoice = generated_invoice
        expect(invoice.invoice_line_items.count).to eq(2)

        package_line = invoice.invoice_line_items.find_by(item_type: 'package')
        expect(package_line.name).to eq(app_package.name)
        expect(package_line.unit_price).to eq(app_package.price)

        add_on_line = invoice.invoice_line_items.find_by(item_type: 'add_on')
        expect(add_on_line.name).to eq(app_add_on.name)
        expect(add_on_line.quantity).to eq(app_add_on.quantity)
      end
    end

    context 'when an invoice already exists' do
      let!(:existing_invoice) { create(:invoice, appointment: appointment) }

      it 'returns the existing invoice' do
        expect(generated_invoice).to eq(existing_invoice)
      end

      it 'does not create a new invoice' do
        expect { generated_invoice }.not_to change { Invoice.count }
      end
    end
  end
end
