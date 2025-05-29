require 'rails_helper'

RSpec.describe Showcase, type: :model do
  let(:store) { create(:store) }
  let!(:showcase) { create(:showcase, store: store) }

  describe 'associations' do
    it { should belong_to(:store) }
    it { should have_many(:photos).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:store_id) }
  end

  describe '#update_photos_count' do
    before do
      showcase.photos.create!(file_key: 'file-key', alt_text: 'alt', image: fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg'))
    end

    context 'when photos_changed attr is true' do
      before { showcase.photos_changed = true }

      it 'updates photos_count after update commit if photos_changed is true' do
        expect {
          showcase.touch
        }.to change { showcase.reload.photos_count }.from(0).to(1)
      end
    end

    context 'when photos_changed attr is false' do
      before { showcase.photos_changed = false }

      it 'does not update photos_count if photos_changed is false' do
        expect {
          showcase.update!(name: 'Another Name')
          showcase.reload
        }.not_to change { showcase.photos_count }
      end
    end
  end
end
