# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField

    def cached_url_for(key, expires_in: 5.minutes)
      if block_given?
        Rails.cache.fetch(key, expires_in: expires_in) { yield }
      else
        Rails.application.routes.url_helpers.url_for(object.image)
      end
    end
  end
end
