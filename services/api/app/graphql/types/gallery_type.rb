# frozen_string_literal: true

module Types
  class GalleryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :slug, String, null: false
    field :photo, Types::PhotoType
    field :collections, [Types::CollectionType]
    field :packages, [Types::PackageType]
    field :add_ons, [Types::AddOnType]
    field :store, Types::StoreType

    def collections
      object.collections.includes(photos: { image_attachment: :blob }).where(active: true)
    end
  end
end
