class RenameSlideshowToShowcase < ActiveRecord::Migration[8.0]
  def change
    remove_column :slideshows, :active
    rename_table :slideshows, :showcases
  end
end
