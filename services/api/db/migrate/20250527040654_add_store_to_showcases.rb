class AddStoreToShowcases < ActiveRecord::Migration[8.0]
  def change
    add_reference :showcases, :store, null: false
    remove_index :showcases, name: "index_showcases_on_name"
    add_index :showcases, %i[store_id name], unique: true
  end
end
