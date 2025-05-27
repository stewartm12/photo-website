require 'rails_helper'

RSpec.describe AppointmentAddOn, type: :model do
  describe 'associations' do
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe '#total_price' do
    let(:store)    { create(:store) }
    let(:customer) { create(:customer, store: store) }
    let(:appointment) { create(:appointment, customer: customer, store: store) }
    let!(:appointment_add_on) { create(:appointment_add_on, appointment: appointment, price: 50, quantity: 2) }

    it 'returns the total amount from price * quantity' do
      expect(appointment_add_on.total_price).to eq(100)
    end
  end
end
