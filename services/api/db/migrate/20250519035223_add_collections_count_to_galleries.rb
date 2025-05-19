class AddCollectionsCountToGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :galleries, :collections_count, :integer, default: 0, null: false
  end
end
