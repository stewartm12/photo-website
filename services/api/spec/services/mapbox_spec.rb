require 'rails_helper'

RSpec.describe Mapbox do
  describe '.autocomplete' do
    let(:query) { 'Some Place' }
    let(:mock_url) { 'mock_base_url' }
    let(:mock_token) { 'mock_access_token' }
    let(:mock_response) do
      {
        'features' => [
          { 'properties' => { 'full_address' => 'Some Place, Country' } },
          { 'properties' => { 'full_address' => 'Another Place, Country' } }
        ]
      }
    end

    before do
      allow(ENV).to receive(:fetch).with('MAPBOX_URL', '').and_return(mock_url)
      allow(ENV).to receive(:fetch).with('MAPBOX_ACCESS_TOKEN', '').and_return(mock_token)
      allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: mock_response))
    end

    it 'calls HTTParty.get with the correct parameters' do
      Mapbox.autocomplete(query)

      expect(HTTParty).to have_received(:get).with(
        mock_url,
        query: { q: query, access_token: mock_token, limit: 5 }
      )
    end

    it 'returns an array of addresses' do
      result = Mapbox.autocomplete(query)

      expect(result).to eq(mock_response)
    end

    context 'when the API request fails' do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError.new('API error'))
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and returns an empty array' do
        result = Mapbox.autocomplete(query)

        expect(result).to eq([])
        expect(Rails.logger).to have_received(:error).with(/Mapbox API error/)
      end
    end
  end
end
