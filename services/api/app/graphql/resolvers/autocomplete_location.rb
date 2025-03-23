module Resolvers
  class AutocompleteLocation < GraphQL::Schema::Resolver
    type [Types::LocationType], null: false

    argument :query, String, required: true

    def resolve(query:)
      results = Mapbox.autocomplete(query)

      results['features'].map do |feature|
        {
          address: feature['properties']['full_address']
        }
      end
    end
  end
end
