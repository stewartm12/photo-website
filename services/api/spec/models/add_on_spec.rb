require 'rails_helper'

RSpec.describe AddOn, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:gallery) }
    it { should have_many(:appointment_add_ons) }
    it { should have_many(:appointments).through(:appointment_add_ons) }
  end
end
