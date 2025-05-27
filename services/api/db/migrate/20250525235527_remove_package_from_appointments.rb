class RemovePackageFromAppointments < ActiveRecord::Migration[8.0]
  def change
    remove_index :appointments, name: 'index_appointments_on_package_id'
    remove_column :appointments, :package_id
  end
end
