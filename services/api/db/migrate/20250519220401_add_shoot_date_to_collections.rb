class AddShootDateToCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :collections, :shoot_date, :date
  end
end
