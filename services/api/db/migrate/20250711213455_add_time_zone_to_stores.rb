class AddTimeZoneToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :time_zone, :string, default: 'UTC', null: false
  end
end
