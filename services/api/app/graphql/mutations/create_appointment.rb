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
      appointment = nil

      ActiveRecord::Base.transaction do
        customer = find_or_create_customer(args)
        appointment = build_appointment(args, customer)

        build_appointment_add_ons(appointment, args[:add_on_ids])
        build_location(appointment, args[:address], args[:note]) if args[:address]

        appointment.save!
      end

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

# it 'returns errors if appointment is invalid' do
#   allow_any_instance_of(Appointment).to receive(:save!).and_raise(
#     ActiveRecord::RecordInvalid.new(Appointment.new.tap { |a| a.errors.add(:base, "Invalid appointment") })
#   )

#   result = described_class.new(object: nil, context: {}).resolve(
#     first_name: "John",
#     last_name: "Doe",
#     email: "john@example.com",
#     phone_number: "1234567890",
#     package_id: 1,
#     add_on_ids: [],
#     address: nil,
#     note: nil
#   )

#   expect(result[:appointment]).to be_nil
#   expect(result[:errors]).to include("Invalid appointment")
# end
