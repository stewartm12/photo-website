class MakeAddOnNameUnique < ActiveRecord::Migration[8.0]
  def change
    add_index :add_ons, %i[gallery_id name], unique: true
  end
end
