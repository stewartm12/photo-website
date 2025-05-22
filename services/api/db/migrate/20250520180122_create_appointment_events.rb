class CreateAppointmentEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :appointment_events do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :event_type, null: false
      t.text :message, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
