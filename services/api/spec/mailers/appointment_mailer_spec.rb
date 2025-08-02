require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  describe '.new_appointment_email' do
    let(:customer) { create(:customer, store: Store.first) }
    let(:gallery) { Gallery.first }
    let(:appointment) { create(:appointment, customer: customer, store: Store.first) }
    let!(:appointment_package) { create(:appointment_package, appointment: appointment) }
    let!(:photo) do
      create(
        :photo,
        imageable: Store.first,
        image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test2.jpg")
      )
    end

    it 'sends the email to the customer and includes the correct BCC' do
      email = AppointmentMailer.new_appointment_email(appointment, customer, Store.first).deliver_now

      expect(email.to).to eq([customer.email])
      expect(email.bcc).to include(Store.first.email)
      expect(email.from).to eq([Store.first.email])
      expect(email.subject).to eq('Photography Appointment Confirmation')
    end
  end
end
