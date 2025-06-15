# frozen_string_literal: true

module Types
  class ShowcaseType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :photos, [Types::PhotoType]
    field :store, Types::StoreType
  end
end
