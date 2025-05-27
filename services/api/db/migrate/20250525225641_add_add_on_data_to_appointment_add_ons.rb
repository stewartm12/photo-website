class AddAddOnDataToAppointmentAddOns < ActiveRecord::Migration[8.0]
  def change
    add_column :appointment_add_ons, :name, :string, null: false
    add_column :appointment_add_ons, :price, :decimal, precision: 10, scale: 2, null: false
    add_column :appointment_add_ons, :limited, :boolean, null: false
  end
end
