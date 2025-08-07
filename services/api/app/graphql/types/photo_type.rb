# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :file_key, String
    field :alt_text, String
    field :section_key, String
    field :position, Int
    field :imageable, Types::ImageableUnion, null: true
    field :image_url, String, null: true do
      argument :size, String, required: false
    end

    def image_url(size: nil)
      return nil unless object.image.attached?

      if Rails.env.development?
        cached_url_for("photo:url:#{object.id}")
      else
        cached_signed_url(object, size)
      end
    end

    def imageable
      object.imageable
    end

    private

    def cached_signed_url(photo, size)
      cached_url_for("photo:signed_url:#{photo.id}:#{size}") do
        variant = case size
        when :thumb
          photo.image.variant(resize_to_limit: [150, 100]).processed
        when :masonry
          photo.image.variant(resize_to_limit: [363, nil]).processed
        when :hero
          photo.image.variant(resize_to_limit: [1147, 830]).processed
        else
          photo.image
        end

        Rails.application.routes.url_helpers.url_for(variant)
      end
    end
  end
end
