# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: 'Fetches an object given its ID.' do
      argument :id, ID, required: true, description: 'ID of the object.'
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: 'Fetches a list of objects given a list of IDs.' do
      argument :ids, [ID], required: true, description: 'IDs of the objects.'
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :galleries, [Types::GalleryType], null: false, description: 'Fetches all galleries.'

    field :gallery, Types::GalleryType, null: true, description: 'Fetches a gallery by ID.' do
      argument :id, ID, required: true, description: 'ID of the gallery.'
    end

    field :slideshow, Types::SlideshowType, null: true, description: 'Fetches a slideshow by name' do
      argument :name, String, required: true, description: 'Name of the slideshow.'
    end

    def galleries
      Gallery.includes(collections: :photos)
    end

    def gallery(id:)
      Gallery.includes(collections: :photos).find_by(id: id)
    end

    def slideshow(name:)
      Slideshow.find_by(name: name)
    end
  end
end
