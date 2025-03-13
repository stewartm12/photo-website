require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe 'associations' do
    it { should have_one(:photo).dependent(:destroy) }
    it { should have_many(:collections).dependent(:destroy) }
  end

  describe 'validations' do
    context 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).case_insensitive }
    end
  end
end
