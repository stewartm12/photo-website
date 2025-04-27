class AddStatusToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :appointments, :status, :integer, default: 0, null: false
    add_index :appointments, :status
  end
end
