class MakeUserIdNullInAppointmentEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :appointment_events, :user_id, true
  end
end
