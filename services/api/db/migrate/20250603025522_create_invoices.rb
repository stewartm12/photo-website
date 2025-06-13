class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :appointments, null: false, foreign_key: true
      t.bigint :invoice_number, null: false
      t.decimal :subtotal, null: false
      t.decimal :tax
      t.decimal :total, null: false
      t.timestamps
    end
  end
end
