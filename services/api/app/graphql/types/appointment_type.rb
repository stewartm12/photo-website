# frozen_string_literal: true

module Types
  class AppointmentType < Types::BaseObject
    field :id, ID, null: false
    field :preferred_date_time, GraphQL::Types::ISO8601DateTime
    field :additional_notes, String
    field :email, String, null: false
    field :phone_number, String
    field :customer, Types::CustomerType, null: false
    field :package, Types::PackageType, null: false
    field :appointment_add_ons, [Types::AppointmentAddOnType]
    field :add_ons, [Types::AddOnType]
    field :store, Types::StoreType, null: false
  end
end
