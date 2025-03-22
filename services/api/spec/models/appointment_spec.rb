require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:gallery) { Gallery.first }
  let(:customer) { create(:customer) }
  let(:package) { create(:package, gallery: gallery) }
  let!(:appointment) { create(:appointment, package: package, customer: customer) }

  describe 'associations' do
    it { should belong_to(:customer) }
    it { should belong_to(:package) }
    it { should have_many(:appointment_add_ons) }
    it { should have_many(:add_ons) }
  end
end
