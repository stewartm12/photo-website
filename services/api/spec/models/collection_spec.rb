require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:gallery) { Gallery.first }
  subject { build(:collection, gallery: gallery) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:gallery_id).with_message('should be unique within the same gallery') }
  end

  describe 'associations' do
    it { should have_many(:photos).dependent(:destroy) }
    it { should belong_to(:gallery) }
  end
end
