class CreateSlideshows < ActiveRecord::Migration[8.0]
  def change
    create_table :slideshows do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
