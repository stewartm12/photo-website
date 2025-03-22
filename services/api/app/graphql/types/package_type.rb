# frozen_string_literal: true

module Types
  class PackageType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :price, String, null: false
    field :edited_images, Int
    field :outfit_change, Boolean
    field :duration, Int
    field :popular, Boolean
    field :features, [String]
    field :gallery, Types::GalleryType, null: false
    field :appointments, [Types::AppointmentType]

    def price
      object.price.to_s
    end
  end
end
