class CreateAppointmentAddOns < ActiveRecord::Migration[8.0]
  def change
    create_table :appointment_add_ons do |t|
      t.references :appointment, null: false
      t.references :add_on, null: false
      t.integer :quantity, default: 1, null: false
      t.timestamps
    end
  end
end
