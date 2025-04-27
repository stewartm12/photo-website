class AttachGalleriesToStores < ActiveRecord::Migration[8.0]
  def change
    add_reference :galleries, :store, null: false, foreign_key: true
  end
end
