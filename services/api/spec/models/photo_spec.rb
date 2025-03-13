require 'rails_helper'

RSpec.describe Photo, type: :model do
  let!(:gallery) { Gallery.first }
  let!(:photo) { create(:photo, file_key: 'file_key_Name', imageable: gallery) }

  describe 'validations' do
    context 'file_key' do
      it { should validate_presence_of(:file_key) }
      it { should validate_uniqueness_of(:file_key) }
    end
  end

  describe 'associations' do
    it { should belong_to(:imageable) }
  end

  describe 'callbacks' do
    it 'downcases the file_key before saving' do
      expect(photo.reload.file_key).to eq('file_key_name')
    end
  end
end
