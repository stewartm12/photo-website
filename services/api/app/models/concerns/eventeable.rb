module Eventeable
  extend ActiveSupport::Concern

  def generate_change_message(attr, from, to)
    "Changed #{attr} from '#{from.inspect}' -> '#{to.inspect}'"
  end

  def log_event(event_type, message, metadata: {})
    metadata = metadata.merge(created_by: Current.user.full_name) if Current.user.present?

    AppointmentEvent.create(
      appointment: respond_to?(:appointment) ? appointment : self,
      user: Current.user,
      event_type: event_type,
      message: message,
      metadata: metadata
    )
  end

  def updated_field(event_type)
    messages = []
    self.class::TRACKED_CHANGES.each do |attr, event_type|
      next unless saved_change_to_attribute?(attr)

      from, to = saved_change_to_attribute(attr)
      messages << generate_change_message(attr, from, to)
    end

    log_event(
      event_type,
      messages.join("\n")
    )
  end
end
