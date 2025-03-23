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

  describe 'encryption' do
    it "encrypts the email field" do
      expect(Customer.connection.execute("SELECT email FROM customers WHERE id = #{customer.id}").first["email"]).not_to eq(customer.email)
    end

    it "encrypts the phone_number field" do
      expect(Customer.connection.execute("SELECT phone_number FROM customers WHERE id = #{customer.id}").first["phone_number"]).not_to eq(customer.phone_number)
    end
  end
end
