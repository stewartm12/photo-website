class AddAppointmentsCountToStore < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :appointments_count, :integer, default: 0, null: false
  end
end
