module Types
  class LocationType < Types::BaseObject
    field :id, ID, null: true
    field :address, String
    field :note, Float
  end
end
