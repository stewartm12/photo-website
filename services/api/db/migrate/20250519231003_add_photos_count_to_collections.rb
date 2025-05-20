class AddPhotosCountToCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :collections, :photos_count, :integer, default: 0, null: false
  end
end
