# spec/support/shared_contexts/appointment_setup.rb
RSpec.shared_context 'with appointment and related records' do
  let(:store)    { create(:store) }
  let(:customer) { create(:customer, store: store) }
  let(:gallery)  { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
  let(:package)  { create(:package, gallery: gallery, price: 30.00) }
  let(:appointment) { build(:appointment, package: package, customer: customer, store: store) }
end

RSpec.shared_context 'with appointment and add-ons' do
  include_context 'with appointment and related records'

  let(:add_on1) { create(:add_on, gallery: gallery, price: 5.00) }
  let(:add_on2) { create(:add_on, gallery: gallery, price: 10.00) }

  before do
    create(:appointment_add_on, appointment: appointment, add_on: add_on1, quantity: 4)
    create(:appointment_add_on, appointment: appointment, add_on: add_on2, quantity: 5)
  end
end
