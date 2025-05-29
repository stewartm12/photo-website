class AddPhotosCountToShowcases < ActiveRecord::Migration[8.0]
  def change
    add_column :showcases, :photos_count, :integer, default: 0, null: false
  end
end
