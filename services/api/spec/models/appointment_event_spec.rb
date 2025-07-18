require 'rails_helper'

RSpec.describe AppointmentEvent, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:appointment) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'enums' do
    it do
      expect(described_class.event_types.keys).to match_array(
        %w[
          appointment_created
          appointment_updated
          add_on_updated
          location_added
          location_updated
          invoice_created
          invoice_updated
          package_updated
        ]
      )
    end
  end
end
