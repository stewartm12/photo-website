class Mapbox
  class << self
    def autocomplete(query)
      response = HTTParty.get(base_url, query: { q: query, access_token: access_token, limit: 5 })

      return [] unless response.success?

      response.parsed_response
    rescue StandardError => e
      Rails.logger.error("Mapbox API error: #{e.message}")
      []
    end

    private

    def base_url
      ENV.fetch('MAPBOX_URL', '')
    end

    def access_token
      ENV.fetch('MAPBOX_ACCESS_TOKEN', '')
    end
  end
end
