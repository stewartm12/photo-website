require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  describe '.new_appointment_email' do
    let(:customer) { create(:customer) }
    let(:gallery) { Gallery.first }
    let(:package) { create(:package, gallery: gallery) }
    let(:appointment) { create(:appointment, customer: customer, package: package) }

    it 'sends the email to the customer and includes the correct BCC' do
      email = AppointmentMailer.new_appointment_email(appointment, customer).deliver_now

      expect(email.to).to eq([customer.email])
      expect(email.bcc).to include(ENV['BCC_EMAIL'])
      expect(email.subject).to eq('Photography Appointment Confirmation')
    end
  end
end
