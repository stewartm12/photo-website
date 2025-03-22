require 'rails_helper'

RSpec.describe AddOn, type: :model do
  let(:gallery) { Gallery.first }
  let!(:add_on) { create(:add_on, gallery: gallery) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:gallery) }
    it { should have_many(:appointment_add_ons) }
    it { should have_many(:appointments) }
  end
end
