require 'rails_helper'

RSpec.describe Types::AddOnType, type: :graphql do
  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:price).of_type('String!') }
    it { is_expected.to have_field(:limited).of_type('Boolean') }
    it { is_expected.to have_field(:gallery).of_type('Gallery!') }
  end

  describe '#price' do
    let(:gallery) { Gallery.first }
    let(:add_on) { create(:add_on, gallery: gallery, price: 10.0) }
    let(:context) { instance_double(GraphQL::Query::Context, query: instance_double(GraphQL::Query)) }
    let(:addon_instance) { described_class.scoped_new(add_on, context) }

    it 'returns the price as a string' do
      expect(addon_instance.price).to eq('10.0')
    end
  end
end
