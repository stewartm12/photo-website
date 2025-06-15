# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :file_key, String
    field :alt_text, String
    field :section_key, String
    field :position, Int
    field :imageable, Types::ImageableUnion, null: true
    field :image_url, String

    def image_url
      return object.file_key unless object.image.attached?

      Rails.application.routes.url_helpers.rails_blob_url(
        object.image,
        protocol: ActiveStorage::Current.url_options[:protocol],
        host: 'localhost',
        port: '3001'
      )
    end

    def imageable
      object.imageable
    end
  end
end
