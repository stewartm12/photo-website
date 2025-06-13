class RenameAppointmentsIdToAppointmentId < ActiveRecord::Migration[8.0]
  def change
    remove_index :invoices, name: 'index_invoices_on_appointments_id'
    rename_column :invoices, :appointments_id, :appointment_id
    add_index :invoices, :appointment_id
  end
end
