class MakePackagesNameUnique < ActiveRecord::Migration[8.0]
  def change
    add_index :packages, %i[gallery_id name], unique: true
  end
end
