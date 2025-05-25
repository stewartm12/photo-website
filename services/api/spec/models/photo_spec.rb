require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe 'validations' do
    subject { build(:photo) }

    context 'file_key' do
      it { should validate_presence_of(:file_key) }
      it { should validate_uniqueness_of(:file_key) }
    end
  end

  describe 'custom validations' do
    let(:photo) { build(:photo) }

    context '#acceptable_image' do
      context 'when image is attached with valid type and size' do
        before { photo.image.attach(Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test.jpg'))) }

        it 'is valid' do
          expect(photo).to be_valid
        end
      end
    end

    context 'when image type is invalid' do
      before { photo.image.attach(Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/fail_test.pdf'))) }

      it 'adds an error on :image' do
        photo.valid?
        expect(photo.errors[:image]).to include('must be a JPEG, PNG, WEBP, or AVIF')
      end
    end

    context 'when image is too large' do
      let(:large_file_path) { Rails.root.join('tmp/large_test.jpg') }

      before do
        # Generate a 6MB dummy file if it doesn't exist
        unless File.exist?(large_file_path)
          File.open(large_file_path, 'wb') { |f| f.write('0' * 15.megabytes) }
        end

        photo.image.attach(
          Rack::Test::UploadedFile.new(large_file_path, 'image/jpeg')
        )
      end

      after(:each) { File.delete(large_file_path) if File.exist?(large_file_path) }

      it 'adds an error on :image' do
        photo.valid?
        expect(photo.errors[:image]).to include('is too big (max 10MB)')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:imageable) }
  end
end
