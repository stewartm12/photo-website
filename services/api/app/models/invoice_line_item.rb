class InvoiceLineItem < ApplicationRecord
  belongs_to :invoice

  validates :name, :item_type, :quantity, :unit_price, :total_price, presence: true
end
