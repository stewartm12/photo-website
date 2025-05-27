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
        build_appointment_package(appointment, args[:package_id])
        build_location(appointment, args[:address], args[:note]) if args[:address]

        appointment.save!

        appointment.appointment_events.create!(event_type: :appointment_created, message: 'Customer booked appointment online', metadata: { created_by: 'online booking' })
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
        phone_number: args[:phone_number],
        store: context[:current_store]
      )

      customer.save!
      customer
    end

    def build_appointment(args, customer)
      customer.appointments.new(
        preferred_date_time: args[:preferred_date_time],
        additional_notes: args[:additional_notes],
        store: context[:current_store]
      )
    end

    def build_appointment_package(appointment, package_id)
      return unless package_id

      package = context[:current_store].packages.find_by(id: package_id)

      appointment.build_appointment_package(
        name: package.name,
        price: package.price,
        edited_images: package.edited_images,
        outfit_change: package.outfit_change,
        duration: package.duration,
        features: package.features,
        gallery_name: package.gallery.name
      )
    end

    def build_appointment_add_ons(appointment, add_on_ids)
      return unless add_on_ids.present?

      add_ons = AddOn.where(id: add_on_ids)

      add_ons.each do |add_on|
        appointment.appointment_add_ons.build(
          quantity: 1,
          name: add_on.name,
          price: add_on.price,
          limited: add_on.limited
        )
      end
    end

    def build_location(appointment, address, note)
      appointment.locations.build(address: address, note: note)
    end
  end
end
