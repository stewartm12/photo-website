class AddPaidAtToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :paid_at, :datetime
    add_column :invoices, :paid_amount, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
