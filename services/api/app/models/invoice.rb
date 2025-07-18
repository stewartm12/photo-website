class Invoice < ApplicationRecord
  include Eventeable

  belongs_to :appointment
  has_many :invoice_line_items, dependent: :destroy

  validates :invoice_number, :subtotal, :total, presence: true

  after_create :log_invoice_created_event
  after_update :log_invoice_updated_event

  enum :status, {
    unpaid: 'unpaid',
    overdue: 'overdue',
    paid: 'paid',
    refunded: 'refunded',
    void: 'void'
  }

  TRACKED_CHANGES = %i[
    status
    paid_amount
    paid_at
  ].freeze

  def amount_due
    total - deposit - paid_amount
  end

  private

  def log_invoice_created_event
    log_event(
      :invoice_created,
      "Invoice ##{invoice_number} has been created."
    )
  end

  def log_invoice_updated_event
    updated_field(:invoice_updated)
  end

  def generate_change_message(attr, from, to)
    case attr
    when :status
      "Updated invoice status from '#{from}' -> '#{to}'"
    when :paid_amount
      "Amount paid #{to}"
    when :paid_at
      "Paid at #{format_time(to)}"
    end
  end

  def format_time(value)
    value.strftime('%B %-d, %Y at %-l:%M %p %Z')
  end
end
