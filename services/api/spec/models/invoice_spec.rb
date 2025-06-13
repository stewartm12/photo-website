require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { should have_many(:invoice_line_items).dependent(:destroy) }
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    context 'invoice_number' do
      it { should validate_presence_of(:invoice_number) }
    end

    context 'subtotal' do
      it { should validate_presence_of(:subtotal) }
    end

    context 'total' do
      it { should validate_presence_of(:total) }
    end
  end

  describe 'enums' do
    it 'has valid statuses' do
      expect(described_class.statuses.keys).to match_array(%w[unpaid overdue paid refunded void])
    end
  end

  describe '#amount_due' do
    let(:customer) { create(:customer, store: store) }
    let(:store) { create(:store) }
    let(:appointment) { create(:appointment, customer: customer, store: store) }
    let(:invoice) { create(:invoice, :paid, appointment: appointment, total: 100.0, deposit: 20.0, paid_amount: 80.0) }

    it 'calculates the amount due' do
      expect(invoice.amount_due).to eq(0)
    end

    context 'when deposit and paid_amount are zero' do
      let(:invoice) { create(:invoice, :unpaid, appointment: appointment, total: 100.0, deposit: 0.0, paid_amount: 0.0) }

      it 'returns the total as amount due' do
        expect(invoice.amount_due).to eq(100.0)
      end
    end
  end
end
