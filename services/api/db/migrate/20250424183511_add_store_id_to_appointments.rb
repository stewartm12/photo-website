class AddStoreIdToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_reference :appointments, :store, null: false, foreign_key: true
  end
end
