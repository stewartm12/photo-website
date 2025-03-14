# app/graphql/types/imageable_type.rb
module Types
  class ImageableUnion < Types::BaseUnion
    description 'Objects that can have photos'

    possible_types Types::PhotoType, Types::CollectionType, Types::GalleryType, Types::SlideshowType

    def self.resolve_type(object, _context)
      case object
      when Photo
        Types::PhotoType
      when Collection
        Types::CollectionType
      when Gallery
        Types::GalleryType
      when Slideshow
        Types::SlideshowType
      else
        raise "Unexpected imageable type: #{object.class}"
      end
    end
  end
end
