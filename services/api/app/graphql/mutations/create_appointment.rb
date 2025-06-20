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

    field :appointment, Types::AppointmentType
    field :errors, [String]

    def resolve(args)
      customer = find_or_create_customer(args)
      appointment = schedule_appointment(customer, args)

      { appointment: appointment, errors: [] }

    rescue ActiveRecord::RecordInvalid => e
      { appointment: nil, errors: appointment&.errors&.full_messages.presence || [e.message] }
    end

    private

    def find_or_create_customer(args)
      customer = Customer.find_or_initialize_by(email: args[:email])

      customer.assign_attributes(
        first_name: args[:first_name],
        last_name: args[:last_name],
        phone_number: args[:phone_number],
        store: context[:current_store]
      )

      customer.save!
      customer
    end

    def schedule_appointment(customer, args)
      ScheduleAppointment.new(store: context[:current_store]).call(
        customer: customer,
        package_id: args[:package_id],
        add_on_ids: args[:add_on_ids],
        preferred_date_time: args[:preferred_date_time],
        additional_notes: args[:additional_notes],
        address: args[:address],
        note: args[:note],
        metadata: { created_by: 'online booking' }
      )
    end
  end
end
