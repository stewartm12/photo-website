require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:package) }
    it { should belong_to(:store) }
    it { should have_many(:appointment_add_ons) }
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
      let(:store) { create(:store) }
      let(:customer) { create(:customer, store: store) }
      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let(:package) { create(:package, gallery: gallery) }
      let(:appointment) { build(:appointment, package: package, customer: customer, store: store) }

      it 'notifies the customer' do
        expect(AppointmentMailer).to deliver_later(:new_appointment_email)

        appointment.save
      end
    end
  end
end
