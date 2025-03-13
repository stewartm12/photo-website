require 'rails_helper'

RSpec.describe Slideshow, type: :model do
  let!(:slideshow) { create(:slideshow) }

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
