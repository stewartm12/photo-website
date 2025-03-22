# frozen_string_literal: true

module Types
  class AppointmentAddOnType < Types::BaseObject
    field :id, ID, null: false
    field :quantity, Int, null: false
    field :appointment, [Types::AppointmentType], null: false
    field :add_on, [Types::AddOnType], null: false
  end
end
