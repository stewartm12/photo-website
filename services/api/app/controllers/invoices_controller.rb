class InvoicesController < ApplicationController
  before_action :set_appointment

  def create
    @invoice = AppointmentInvoiceGenerator.new(Current.store, @appointment).call

    if @invoice.persisted?
      @event = @appointment.appointment_events.last
      flash.now[:success] = 'Invoice created succesfully'
    else
      flash.now[:alert] = @invoice.errors.full_messages.to_sentence
    end
  end

  def update
    invoice = @appointment.invoice

    unless Invoice.statuses.key?(invoice_params[:status])
      flash.now[:alert] = 'Status is not included in the list' and return
    end

    invoice.update(status: invoice_params[:status], paid_amount: invoice.amount_due, paid_at: Time.current)
    @event = @appointment.appointment_events.last
    flash.now[:success] = 'Invoice updated successfully'
  end

  def download
    pdf = InvoicePdfRenderer.new(@appointment.invoice).render

    send_data pdf,
      filename: "invoice-#{@appointment.customer.full_name.parameterize}-#{@appointment.invoice.invoice_number}.pdf",
      type: 'application/pdf',
      disposition: 'attachment'
  end

  private

  def invoice_params
    params.expect(invoice: [:status])
  end

  def set_appointment
    @appointment = Current.store.appointments.find_by(id: params[:appointment_id])
  end
end
