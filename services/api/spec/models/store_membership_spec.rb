require 'rails_helper'

RSpec.describe StoreMembership, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:store) }
  end
end
