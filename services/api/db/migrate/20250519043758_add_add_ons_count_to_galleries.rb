class AddAddOnsCountToGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :galleries, :add_ons_count, :integer, default: 0, null: false
  end
end
