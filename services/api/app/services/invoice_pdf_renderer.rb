class InvoicePdfRenderer
  def initialize(invoice)
    @invoice = invoice
    @appointment = invoice.appointment
    @store = @appointment.store
  end

  def render
    line_items = header_row + invoice_rows + totals_rows

    status_color = status_color_for(@invoice.status)

    Receipts::Invoice.new(
      company: company_info,
      logo_height: 50,
      recipient: recipient_info,
      details: invoice_details(status_color),
      line_items: line_items,
      footer: footer_message
    ).render
  end

  private

  def header_row
    [['<b>Item</b>', '<b>Unit Cost</b>', '<b>Quantity</b>', '<b>Amount</b>']]
  end

  def invoice_rows
    @invoice.invoice_line_items.map do |line|
      [
        line.name,
        price_format(line.unit_price),
        line.quantity,
        price_format(line.total_price)
      ]
    end
  end

  def totals_rows
    [
      [nil, nil, 'Subtotal', price_format(@invoice.subtotal)],
      [nil, nil, 'Tax Rate', '0%'],
      [nil, nil, 'Total', price_format(@invoice.total)],
      [nil, nil, 'Deposit Paid', "-#{price_format(@invoice.deposit)}"],
      [nil, nil, 'Amount Paid', "-#{price_format(@invoice.paid_amount)}"],
      [nil, nil, '<b>Amount Due</b>', price_format(@invoice.amount_due)]
    ]
  end

  def status_color_for(status)
    case status&.downcase
    when 'paid' then '#5eba7d'
    when 'unpaid' then '#e74c3c'
    else '#000000'
    end
  end

  def company_info
    {
      name: @store.name,
      address: @store.domain,
      email: @store.email,
      logo: Rails.root.join('app/assets/images/Logo.png')
    }
  end

  def recipient_info
    [
      '<b>Bill To</b>',
      @appointment.customer.full_name,
      @appointment.customer.email
    ]
  end

  def invoice_details(status_color)
    [
      ['Invoice Number', @invoice.invoice_number],
      ['Issue Date', @invoice.created_at.strftime('%B %d, %Y')],
      ['Status', "<b><color rgb='#{status_color}'>#{@invoice.status.upcase}</color></b>"]
    ]
  end

  def footer_message
    "Thank you for choosing <b>#{@store.name}</b> for your photography session. We hope you love your photos as much as we loved capturing them."
  end

  def price_format(amount)
    ActiveSupport::NumberHelper.number_to_currency(amount)
  end
end
