# frozen_string_literal: true

module Types
  class GalleryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :slug, String, null: false
    field :photo, Types::PhotoType
    field :collections, [Types::CollectionType]
  end
end
