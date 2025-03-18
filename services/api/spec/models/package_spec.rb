require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:gallery) { Gallery.first }
  let!(:package) { create(:package, gallery: gallery) }

  describe 'associations' do
    it { should belong_to(:gallery) }
  end

  describe 'associations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:gallery) }
  end
end
