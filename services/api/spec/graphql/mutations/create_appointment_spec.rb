require 'rails_helper'

RSpec.describe Mutations::CreateAppointment, type: :request do
  let(:package) { create(:package, gallery: Gallery.first) }
  let(:add_on) { create(:add_on, gallery: Gallery.first) }

  let(:mutation) do
    <<~GQL
      mutation CreateAppointment($input: CreateAppointmentInput!) {
        createAppointment(input: $input) {
          appointment {
            id
            preferredDateTime
          }
          errors
        }
      }
    GQL
  end

  describe '#resolve' do
    context 'when input is valid' do
      let(:variables) do
        {
          input: {
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            phoneNumber: '1234567890',
            preferredDateTime: '2025-03-25T21:30:00Z',
            additionalNotes: 'This is a test note',
            packageId: package.id.to_s,
            addOnIds: [add_on.id.to_s]
          }
        }
      end

      it 'creates an appointment successfully' do
        expect do
          post '/graphql', params: { query: mutation, variables: variables }
        end.to change(Appointment, :count).by(1)
         .and change(AppointmentAddOn, :count).by(1)
         .and change(Customer, :count).by(1)

        expect(Customer.last.email).to eq('john@example.com')
      end
    end

    context 'when input is invalid' do
      context 'when a package Id is not sent' do
        let(:variables) do
          {
            input: {
              firstName: 'John',
              lastName: 'Doe',
              email: 'john@example.com',
              addOnIds: [add_on.id.to_s]
            }
          }
        end

        it 'returns an error' do
          post '/graphql', params: { query: mutation, variables: variables }

          json_response = JSON.parse(response.body)
          expect(json_response).to have_key('errors')
          expect(json_response['errors'].first['message']).to eq(
            'Variable $input of type CreateAppointmentInput! was provided invalid value for packageId (Expected value to not be null)'
          )
        end
      end
    end
  end
end
