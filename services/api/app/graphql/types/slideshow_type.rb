# frozen_string_literal: true

module Types
  class SlideshowType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :active, Boolean, null: false
    field :photos, [Types::PhotoType]
  end
end
