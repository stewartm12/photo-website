class CreateAddOns < ActiveRecord::Migration[8.0]
  def change
    create_table :add_ons do |t|
      t.references :gallery, null: false
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2
      t.boolean :limited, default: false
      t.timestamps
    end
  end
end
