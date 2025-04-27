require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject do
    create(
      :customer,
      store: Store.first,
      first_name: 'john',
      last_name: 'doe',
      phone_number: '1234567890'
    )
  end

  describe 'associations' do
    it { should have_many(:appointments) }
    it { should belong_to(:store) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'callbacks' do
    context 'before_create' do
      it 'capitalizes first and last names' do
        expect(subject.first_name).to eq('John')
        expect(subject.last_name).to eq('Doe')
      end
    end
  end

  describe 'encryption' do
    it 'encrypts the phone_number' do
      should satisfy { |a| a.encrypted_attribute?(:phone_number) }
    end
  end

  describe '#full_name' do
    it 'returns the full name of the customer' do
      expect(subject.full_name).to eq('John Doe')
    end
  end
end
