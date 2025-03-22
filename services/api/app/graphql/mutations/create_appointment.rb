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

    field :appointment, Types::AppointmentType, null: false
    field :errors, [String]

    def resolve(args)
      customer = find_or_create_customer(args)

      appointment = Appointment.new(
        customer: customer,
        package_id: args[:package_id],
        preferred_date_time: args[:preferred_date_time],
        additional_notes: args[:additional_notes]
      )

      if appointment.save
        if args[:add_on_ids]
          args[:add_on_ids].each do |add_on_id|
            AppointmentAddOn.create(
              appointment: appointment,
              add_on_id: add_on_id,
            )
          end
        end

        { appointment: appointment, errors: [] }
      else
        { appointment: nil, errors: appointment.errors.full_messages }
      end
    end

    private

    def find_or_create_customer(args)
      customer = Customer.find_or_initialize_by(email: args[:email])

      customer.assign_attributes(
        first_name: args[:first_name],
        last_name: args[:last_name],
        phone_number: args[:phone_number]
      )

      customer.save
      customer
    end
  end
end
