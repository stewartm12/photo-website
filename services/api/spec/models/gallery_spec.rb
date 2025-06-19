require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe 'associations' do
    it { should have_one(:photo).dependent(:destroy) }
    it { should have_many(:collections).dependent(:destroy) }
    it { should have_many(:photos).through(:collections) }
    it { should have_many(:packages).dependent(:destroy) }
    it { should have_many(:add_ons).dependent(:destroy) }
    it { should belong_to(:store) }
  end

  describe 'validations' do
    context 'name' do
      it { should validate_presence_of(:name) }
    end

    context 'slug' do
      it { should validate_presence_of(:slug) }
    end
  end

  describe 'before_validation' do
    context '#generate_slug' do
      let(:gallery) { create(:gallery, name: 'My Gallery', store: Store.first) }

      it 'generates slug from name' do
        expect(gallery.slug).to eq('my-gallery')
      end
    end
  end

  describe 'before_save' do
    let(:gallery) do
      create(:gallery,
        name: 'second gallery',
        store: Store.first,
        description: 'this is the description')
    end

    context '#titleize_name' do
      it 'should titleize the name' do
        expect(gallery.name).to eq('Second Gallery')
      end
    end

    context '#capitalize_description' do
      it 'should capitalize the first word in the description' do
        expect(gallery.description).to eq('This is the description')
      end
    end
  end
end
