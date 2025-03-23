require 'rails_helper'

RSpec.describe Resolvers::AutocompleteLocation do
  include GraphQL::Testing::Helpers.for(ApiSchema)

  describe '#resolve' do
    subject(:resolved_result) { resolver.resolve(query: query) }

    let(:query_ctx) { GraphQL::Query.new(ApiSchema, "{ __typename }").context }
    let(:field) { instance_double(GraphQL::Schema::Field) }
    let(:resolver) { described_class.new(object: nil, context: query_ctx, field: field) }
    let(:query) { 'New York' }
    let(:mock_response) do
      {
        'features' => [
          { 'properties' => { 'full_address' => 'New York, NY, USA' } },
          { 'properties' => { 'full_address' => 'New York City, NY, USA' } }
        ]
      }
    end

    before do
      allow(Mapbox).to receive(:autocomplete).with(query).and_return(mock_response)
    end

    it 'calls Mapbox.autocomplete with the given query' do
      resolved_result
      expect(Mapbox).to have_received(:autocomplete).with(query)
    end

    it 'returns an array of addresses' do
      expect(resolved_result).to eq([
        { address: 'New York, NY, USA' },
        { address: 'New York City, NY, USA' }
      ])
    end
  end
end
