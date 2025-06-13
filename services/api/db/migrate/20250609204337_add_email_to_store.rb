class AddEmailToStore < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :email, :string
  end
end
