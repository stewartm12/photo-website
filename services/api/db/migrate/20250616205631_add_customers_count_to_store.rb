class AddCustomersCountToStore < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :customers_count, :integer, default: 0, null: false
  end
end
