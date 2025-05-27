# spec/support/shared_contexts/appointment_setup.rb
RSpec.shared_context 'with appointment and related records' do
  let(:store)    { create(:store) }
  let(:customer) { create(:customer, store: store) }
  let(:gallery)  { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
  let(:appointment) { build(:appointment, customer: customer, store: store) }
  let!(:appointment_package) { build(:appointment_package, appointment: appointment, price: 50) }
end

RSpec.shared_context 'with appointment and add-ons' do
  include_context 'with appointment and related records'

  before do
    create(:appointment_add_on, appointment: appointment, quantity: 4)
    create(:appointment_add_on, appointment: appointment, quantity: 5)
  end
end
