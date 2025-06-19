class AddUniqueIndexToGalleriesNameAndSlugByStore < ActiveRecord::Migration[8.0]
  def change
    add_index :galleries, %i[store_id name], unique: true
    add_index :galleries, %i[store_id slug], unique: true
  end
end
