class ChangeInvoiceNumberToString < ActiveRecord::Migration[8.0]
  def change
    change_column :invoices, :invoice_number, :string
    add_index :invoices, :invoice_number, unique: true
  end
end
