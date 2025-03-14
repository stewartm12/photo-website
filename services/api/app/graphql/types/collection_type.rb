# frozen_string_literal: true

module Types
  class CollectionType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :gallery, Types::GalleryType, null: false
    field :photos, [Types::PhotoType]
  end
end
