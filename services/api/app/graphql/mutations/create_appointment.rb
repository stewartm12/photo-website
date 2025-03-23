module Mutations
  class CreateAppointment < BaseMutation
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :email, String, required: true
    argument :phone_number, String, required: false
    argument :preferred_date_time, GraphQL::Types::ISO8601DateTime, required: false
    argument :additional_notes, String, required: false
    argument :package_id, ID, required: true
    argument :add_on_ids, [ID], required: false
    argument :address, String, required: false
    argument :note, String, required: false

    field :appointment, Types::AppointmentType, null: false
    field :errors, [String]

    def resolve(args)
      ActiveRecord::Base.transaction do
        customer = find_or_create_customer(args)
        appointment = build_appointment(args, customer)

        build_appointment_add_ons(appointment, args[:add_on_ids])
        build_location(appointment, args[:address], args[:note]) if args[:address]

        if appointment.save!
          return { appointment: appointment, errors: [] }
        else
          return { appointment: nil, errors: appointment.errors.full_messages }
        end
      end
      { appointment: nil, errors: ['Failed to create appointment'] }
    end

    private

    def find_or_create_customer(args)
      customer = Customer.find_or_initialize_by(email: args[:email])

      customer.assign_attributes(
        first_name: args[:first_name],
        last_name: args[:last_name],
        phone_number: args[:phone_number]
      )

      customer.save!
      customer
    end

    def build_appointment(args, customer)
      customer.appointments.new(
        package_id: args[:package_id],
        preferred_date_time: args[:preferred_date_time],
        additional_notes: args[:additional_notes]
      )
    end

    def build_appointment_add_ons(appointment, add_on_ids)
      return unless add_on_ids

      add_on_ids.each do |id|
        appointment.appointment_add_ons.build(add_on_id: id)
      end
    end

    def build_location(appointment, address, note)
      appointment.locations.build(address: address, note: note)
    end
  end
end
