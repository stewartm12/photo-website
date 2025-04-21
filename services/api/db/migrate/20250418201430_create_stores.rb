class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :domain, null: false
      t.string :slug, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :stores, :slug, unique: true
    add_index :stores, :domain, unique: true
  end
end
