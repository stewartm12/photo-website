class RenameInvoicesIdToInvoiceIdInInvoiceLineItems < ActiveRecord::Migration[8.0]
  def change
    remove_index :invoice_line_items, name: 'index_invoice_line_items_on_invoices_id'
    rename_column :invoice_line_items, :invoices_id, :invoice_id
    add_index :invoice_line_items, :invoice_id
  end
end
