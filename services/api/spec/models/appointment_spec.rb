require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:package) }
    it { should belong_to(:store) }
    it { should have_many(:appointment_add_ons) }
    it { should have_many(:appointment_events) }
    it { should have_many(:add_ons) }
    it { should have_many(:locations) }
  end

  describe 'status enum' do
    it { should define_enum_for(:status).with_values(
      pending: 0,
      confirmed: 1,
      in_progress: 2,
      editing: 3,
      delivered: 4,
      completed: 5,
      cancelled: 6,
      no_show: 7
    ) }
  end

  describe 'callbacks' do
    context 'after_create' do
      include_context 'with appointment and related records'

      it 'notifies the customer' do
        expect(AppointmentMailer).to deliver_later(:new_appointment_email)

        appointment.save
      end
    end
  end

  describe '#package_price' do
    include_context 'with appointment and related records'

    it 'returns the package price' do
      expect(appointment.package_price).to eq(package.price)
    end
  end

  describe '#add_ons_price' do
    include_context 'with appointment and related records'

    let(:add_on1) { create(:add_on, gallery: gallery, price: 5.00) }
    let(:add_on2) { create(:add_on, gallery: gallery, price: 10.00) }

    before do
      create(:appointment_add_on, appointment: appointment, add_on: add_on1, quantity: 4)
      create(:appointment_add_on, appointment: appointment, add_on: add_on2, quantity: 5)
    end

    it 'returns the sum of the add-ons price' do
      expect(appointment.add_ons_price).to eq(70.00)
    end
  end

  describe '#total_price' do
    include_context 'with appointment and related records'

    let(:add_on1) { create(:add_on, gallery: gallery, price: 5.00) }
    let(:add_on2) { create(:add_on, gallery: gallery, price: 10.00) }

    before do
      create(:appointment_add_on, appointment: appointment, add_on: add_on1, quantity: 4)
      create(:appointment_add_on, appointment: appointment, add_on: add_on2, quantity: 5)
    end

    it 'returns the total price of the appointment' do
      expect(appointment.total_price).to eq(70.00 + package.price)
    end
  end
end
