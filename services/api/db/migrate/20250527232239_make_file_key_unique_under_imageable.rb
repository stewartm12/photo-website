class MakeFileKeyUniqueUnderImageable < ActiveRecord::Migration[8.0]
  def change
    remove_index :photos, name: 'index_photos_on_file_key'
    add_index :photos, %i[imageable_type imageable_id file_key], unique: true
  end
end
