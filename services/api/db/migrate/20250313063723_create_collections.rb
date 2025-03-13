class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :name, null: false
      t.references :gallery, null: false
      t.timestamps
    end

    add_index :collections, %i[gallery_id name], unique: true
  end
end
