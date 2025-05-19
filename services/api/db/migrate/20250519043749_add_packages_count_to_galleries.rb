class AddPackagesCountToGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :galleries, :packages_count, :integer, default: 0, null: false
  end
end
