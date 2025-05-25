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

  describe 'callbacks' do
    context '#update_photos_count' do
      context 'when photos_changed attr is set to true' do
        let(:gallery) { create(:gallery) }
        let(:collection) { create(:collection, gallery: gallery) }
        let!(:photo1) { create(:photo, imageable: collection) }
        let!(:photo2) { create(:photo, imageable: collection) }

        it 'updates the photos_count for the collection' do
          expect {
            collection.photos_changed =  true
            collection.touch
          }.to change { collection.reload.photos_count }.by(2)
        end
      end

      context 'when photos_changed attr is not set' do
        let(:gallery) { create(:gallery) }
        let(:collection) { create(:collection, gallery: gallery) }

        it 'does not update the photos count for the collection' do
          expect {
            collection.update(name: 'New Collection Name')
        }.not_to change { collection.reload.photos_count }
        end
      end
    end
  end
end
