class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :customer, null: false
      t.references :package, null: false
      t.datetime :preferred_date_time
      t.text :additional_notes
      t.timestamps
    end
  end
end
