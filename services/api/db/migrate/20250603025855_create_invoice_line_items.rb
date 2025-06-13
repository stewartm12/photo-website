class CreateInvoiceLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_line_items do |t|
      t.references :invoices, null: false, foreign_key: true
      t.string :name, null: false
      t.string :item_type, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, null: false
      t.decimal :total_price, null: false
      t.timestamps
    end
  end
end
