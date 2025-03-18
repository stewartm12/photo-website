require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe 'associations' do
    it { should have_one(:photo).dependent(:destroy) }
    it { should have_many(:collections).dependent(:destroy) }
    it { should have_many(:packages).dependent(:destroy) }
    it { should have_many(:add_ons).dependent(:destroy) }
  end

  describe 'validations' do
    context 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).case_insensitive }
    end

    context 'slug' do
      it { should validate_presence_of(:slug) }
      it { should validate_uniqueness_of(:slug).case_insensitive }

      context 'before validation' do
        let(:gallery) { create(:gallery, name: 'My Gallery') }

        it 'generates slug from name' do
          expect(gallery.slug).to eq('my-gallery')
        end
      end
    end
  end
end
