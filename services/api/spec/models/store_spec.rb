require 'rails_helper'

RSpec.describe Store, type: :model do
  subject { create(:store, name: 'My Store', owner: User.first) }

  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should have_many(:store_memberships) }
    it { should have_many(:users).through(:store_memberships) }
    it { should have_many(:galleries) }
    it { should have_many(:collections).through(:galleries) }
    it { should have_many(:appointments) }
    it { should have_many(:customers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:domain) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:domain).case_insensitive }
    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'callbacks' do
    context 'before_validation' do
      it 'generates slug from name' do
        expect(subject.slug).to eq('my-store')
      end
    end
  end
end
