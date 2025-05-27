class CreateAppointmentPackages < ActiveRecord::Migration[8.0]
  def change
    create_table :appointment_packages do |t|
      t.references :appointment, null: false
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :edited_images, default: 0
      t.boolean :outfit_change, default: false
      t.integer :duration, default: 0
      t.string :features, default: [], array: true
      t.string :gallery_name, null: false
      t.timestamps
    end
  end
end
