class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.string :file_key, null: false
      t.string :alt_text
      t.references :imageable, polymorphic: true
      t.timestamps
    end

    add_index :photos, :file_key, unique: true
  end
end
