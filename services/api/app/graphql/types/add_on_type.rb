# frozen_string_literal: true

module Types
  class AddOnType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :price, String, null: false
    field :limited, Boolean
    field :gallery, Types::GalleryType, null: false

    def price
      object.price.to_s
    end
  end
end
