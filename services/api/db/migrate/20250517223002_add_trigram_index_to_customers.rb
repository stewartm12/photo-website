class AddTrigramIndexToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_index :customers,
      %i[first_name last_name email],
      opclass: :gin_trgm_ops,
      using: :gin
  end
end
