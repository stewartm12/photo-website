require 'rails_helper'

RSpec.describe AddOn, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:gallery) }
  end
end
