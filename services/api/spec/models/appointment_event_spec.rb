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
          status_changed
          appointment_rescheduled
          add_on_added
          add_on_removed
          location_added
          location_removed
          location_updated
          note_updated
          customer_updated
          package_changed
        ]
      )
    end
  end
end
