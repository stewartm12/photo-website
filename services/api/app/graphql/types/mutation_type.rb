# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_appointment, mutation: Mutations::CreateAppointment
  end
end
