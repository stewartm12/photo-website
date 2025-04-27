require 'rails_helper'

RSpec.describe AppointmentAddOn, type: :model do
  describe 'associations' do
    it { should belong_to(:appointment) }
    it { should belong_to(:add_on) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
  end
end
