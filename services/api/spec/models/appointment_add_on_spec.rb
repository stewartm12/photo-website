require 'rails_helper'

RSpec.describe AppointmentAddOn, type: :model do
  let(:gallery) { Gallery.first }
  let(:add_on) { create(:add_on, gallery: gallery) }
  let(:customer) { create(:customer) }
  let(:package) { create(:package, gallery: gallery) }
  let(:appointment) { create(:appointment, package: package, customer: customer) }
  let!(:ap_add_on) { create(:appointment_add_on, appointment: appointment, add_on: add_on) }

  describe 'associations' do
    it { should belong_to(:appointment) }
    it { should belong_to(:add_on) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
  end
end
