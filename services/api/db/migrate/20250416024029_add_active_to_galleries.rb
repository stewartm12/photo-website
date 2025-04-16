class AddActiveToGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :galleries, :active, :boolean, default: false
  end
end
