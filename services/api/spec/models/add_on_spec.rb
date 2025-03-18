require 'rails_helper'

RSpec.describe AddOn, type: :model do
  let!(:gallery) { Gallery.first }
  let(:add_on) { create(:add_on, gallery: gallery) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:gallery) }
  end

  describe 'associations' do
    it { should belong_to(:gallery) }
  end
end
