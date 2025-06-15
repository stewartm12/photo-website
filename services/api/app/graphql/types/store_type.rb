# frozen_string_literal: true

module Types
  class StoreType < Types::BaseObject
    field :id, ID, null: false
    field :domain, String, null: false
    field :slug, String, null: false
  end
end
