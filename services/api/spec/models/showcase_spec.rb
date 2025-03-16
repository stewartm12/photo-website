require 'rails_helper'

RSpec.describe Showcase, type: :model do
  let!(:showcase) { create(:showcase) }

  describe 'validations' do
    context 'name' do
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end
  end

  describe 'associations' do
    it { should have_many(:photos) }
  end
end
