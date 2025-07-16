module Appointments
  class UpdateAddOns
    def initialize(appointment:, add_on_params:, current_user:)
      @appointment = appointment
      @params = add_on_params
      @current_user = current_user
      @messages = []
    end

    def call
      Appointment.transaction do
        existing = @appointment.appointment_add_ons.index_by(&:name)
        incoming = parsed_add_ons.index_by { |a| a[:name] }

        (existing.keys - incoming.keys).each { |name| @messages << "Removed add-on '#{name}'" }

        parsed_add_ons.each do |add_on|
          prev = existing[add_on[:name]]

          if prev.nil?
            @messages << "Added add-on '#{add_on[:name]}' (x#{add_on[:quantity]}) for $#{'%.2f' % (add_on[:price] * add_on[:quantity])}"
          elsif prev.quantity != add_on[:quantity]
            @messages << "Updated add-on '#{add_on[:name]}': quantity changed from '#{prev.quantity}' -> '#{add_on[:quantity]}'"
          end
        end

        log_event
        @appointment.appointment_add_ons.destroy_all
        parsed_add_ons.each { |attrs| @appointment.appointment_add_ons.create!(attrs) }
      end
    end

    private

    def parsed_add_ons
      @parsed_add_ons ||= @params.values.map do |param|
        add_on = AddOn.find(param[:add_on_id])
        {
          name: add_on.name,
          price: add_on.price,
          limited: add_on.limited,
          quantity: param[:quantity].to_i
        }
      end
    end

    def log_event
      @appointment.appointment_events.create!(
        user: @current_user,
        event_type: :add_on_updated,
        message: @messages.join("\n"),
        metadata: { created_by: @current_user&.full_name }
      )
    end
  end
end
