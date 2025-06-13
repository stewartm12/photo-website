class AppointmentInvoiceGenerator
  def initialize(store, appointment)
    @appointment = appointment
    @store = store
  end

  def call
    return @appointment.invoice if @appointment.invoice.present?

    ActiveRecord::Base.transaction do
      invoice = Invoice.create!(
        appointment: @appointment,
        invoice_number: generate_invoice_number,
        subtotal: subtotal,
        tax: tax,
        deposit: @appointment.deposit,
        total: total
      )

      add_package_line(invoice)
      add_add_on_lines(invoice)

      invoice
    end
  end

  private

  def generate_invoice_number
    "INV-#{Time.current.strftime('%Y%m%d')}-#{@appointment.id}"
  end

  def subtotal
    @appointment.total_price
  end

  def total
    subtotal + tax
  end

  def tax
    0 # No tax for now
  end

  def add_package_line(invoice)
    package = @appointment.appointment_package
    return unless package

    invoice.invoice_line_items.create!(
      name: package.name,
      item_type: 'package',
      quantity: 1,
      unit_price: package.price,
      total_price: package.price
    )
  end

  def add_add_on_lines(invoice)
    @appointment.appointment_add_ons.each do |add_on|
      invoice.invoice_line_items.create!(
        name: add_on.name,
        item_type: 'add_on',
        quantity: add_on.quantity,
        unit_price: add_on.price,
        total_price: add_on.total_price
      )
    end
  end
end
