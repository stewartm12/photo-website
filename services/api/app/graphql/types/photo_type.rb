# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :file_key, String
    field :alt_text, String
    field :section_key, String
    field :position, Int
    field :imageable, Types::ImageableUnion, null: true

    def imageable
      object.imageable
    end
  end
end
