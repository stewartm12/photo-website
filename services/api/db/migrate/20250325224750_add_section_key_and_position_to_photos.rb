class AddSectionKeyAndPositionToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :section_key, :string, default: nil
    add_column :photos, :position, :integer, default: nil
  end
end
