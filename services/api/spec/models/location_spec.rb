require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:gallery) { Gallery.first }
  let(:add_on) { create(:add_on, gallery: gallery) }
  let(:customer) { create(:customer, store: Store.first) }
  let(:appointment) { create(:appointment, customer: customer, store: Store.first) }
  let!(:location) { create(:location, appointment: appointment) }

  describe 'associations' do
    it { should belong_to(:appointment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:address) }
  end

  describe 'encryption' do
    it "encrypts the note field" do
      expect(Location.connection.execute("SELECT note FROM locations WHERE id = #{location.id}").first["note"]).not_to eq(location.note)
    end

    it "encrypts the address field" do
      expect(Location.connection.execute("SELECT address FROM locations WHERE id = #{location.id}").first["address"]).not_to eq(location.address)
    end
  end
end
