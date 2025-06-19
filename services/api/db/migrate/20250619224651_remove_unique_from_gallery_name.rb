class RemoveUniqueFromGalleryName < ActiveRecord::Migration[8.0]
  def change
    remove_index :galleries, :name, name: 'index_galleries_on_name'
    remove_index :galleries, :slug, name: 'index_galleries_on_slug'
  end
end
