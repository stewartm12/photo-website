class Invoice < ApplicationRecord
  belongs_to :appointment
  has_many :invoice_line_items, dependent: :destroy

  validates :invoice_number, :subtotal, :total, presence: true

  enum :status, {
    unpaid: 'unpaid',
    overdue: 'overdue',
    paid: 'paid',
    refunded: 'refunded',
    void: 'void'
  }

  def amount_due
    total - deposit - paid_amount
  end
end
