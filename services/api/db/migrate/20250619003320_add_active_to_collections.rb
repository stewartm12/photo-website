class AddActiveToCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :collections, :active, :boolean, default: false, null: false
  end
end
