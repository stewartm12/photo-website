class CreatePackages < ActiveRecord::Migration[8.0]
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :edited_images, default: 0
      t.boolean :outfit_change, default: false
      t.integer :duration
      t.boolean :popular, default: false
      t.string :features, default: [], array: true
      t.references :gallery, null: false
      t.timestamps
    end
  end
end
