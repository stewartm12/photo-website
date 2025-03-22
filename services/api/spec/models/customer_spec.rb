require 'rails_helper'

RSpec.describe Customer, type: :model do
  let!(:customer) { create(:customer) }

  describe 'associations' do
    it { should have_many(:appointments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
