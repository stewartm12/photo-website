RSpec.describe User, type: :model do
  let!(:user) { create(:user, first_name: 'john', last_name: 'doe') }

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:email_address) }
    it { should validate_uniqueness_of(:email_address).case_insensitive }
    it { should allow_value('test1@example.com').for(:email_address) }
    it { should_not allow_value('invalid_email').for(:email_address) }
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:store_memberships) }
    it { should have_many(:stores).through(:store_memberships) }
  end

  describe '#capitalize_names' do
    it 'capitalizes first and last name' do
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Doe')
    end
  end

  describe '#full_name' do
    it 'returns the full name as "first_name last_name"' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  # Test the has_secure_password functionality
  describe 'password validation' do
    let(:user) { build(:user, password: nil) }

    it 'requires a password' do
      expect(user.valid?).to be_falsey
      expect(user.errors[:password_digest]).to include("can't be blank")
    end

    context 'when password is set' do
      before do
        user.password = 'password'
        user.save
      end

      it 'authenticates with correct password' do
        expect(user.authenticate('password')).to be_truthy
      end

      it 'does not authenticate with incorrect password' do
        expect(user.authenticate('wrong_password')).to be_falsey
      end
    end
  end
end
