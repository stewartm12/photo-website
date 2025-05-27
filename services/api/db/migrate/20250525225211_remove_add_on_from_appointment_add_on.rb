class RemoveAddOnFromAppointmentAddOn < ActiveRecord::Migration[8.0]
  def change
    remove_index :appointment_add_ons, name: 'index_appointment_add_ons_on_add_on_id'
    remove_column :appointment_add_ons, :add_on_id
  end
end
