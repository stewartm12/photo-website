require 'rails_helper'

RSpec.describe Mutations::CreateAppointment, type: :request do
  let(:store2) { create(:store) }
  let(:gallery) { create(:gallery, store: store2) }
  let!(:package) { create(:package, gallery: gallery) }
  let!(:add_on) { create(:add_on, gallery: gallery) }

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
    context 'when request is unauthorized' do
      let(:variables) do
        {
          input: {
            firstName: 'John',
            lastName: 'Doe'
          }
        }
      end

      it 'returns an unauthorized error' do
        post '/graphql', params: { query: mutation, variables: variables }

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)).to match({ 'error' => 'Unauthorized' })
      end
    end

    context 'when request is authorized' do
      let(:variables) do
        {
          input: {
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            packageId: package.id.to_s
          }
        }
      end

      it 'returns a 200' do
        post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => ENV['API_ACCESS_TOKEN'], 'X-Store-Domain' => store2.domain  }
        expect(response.status).to eq(200)
      end

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
            post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => ENV['API_ACCESS_TOKEN'], 'X-Store-Domain' => store2.domain  }
          end.to change(Appointment, :count).by(1)
          .and change(AppointmentAddOn, :count).by(1)
          .and change(Customer, :count).by(1)

          expect(Customer.last.email).to eq('john@example.com')
        end

        context 'when an address is present' do
          before { variables[:input][:address] = Faker::Address.full_address }

          it 'successfully creates a new location record' do
            expect do
              post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => ENV['API_ACCESS_TOKEN'], 'X-Store-Domain' => store2.domain  }
            end.to change(Location, :count).by(1)
          end
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
            post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => ENV['API_ACCESS_TOKEN'], 'X-Store-Domain' => store2.domain  }

            json_response = JSON.parse(response.body)
            expect(json_response).to have_key('errors')
            expect(json_response['errors'].first['message']).to eq(
              'Variable $input of type CreateAppointmentInput! was provided invalid value for packageId (Expected value to not be null)'
            )
          end
        end

        context 'when transaction fails' do
          let(:variables) do
            {
              input: {
                firstName: 'John',
                lastName: 'Doe',
                email: 'john@example.com',
                addOnIds: [add_on.id.to_s],
                packageId: package.id.to_s
              }
            }
          end

          let(:exception) do
            e = ActiveRecord::RecordInvalid.new(Appointment.new)
            allow(e).to receive(:message).and_return('Invalid appointment')
            e
          end

          before { allow_any_instance_of(Appointment).to receive(:save!).and_raise(exception) }

          it 'returns an error' do
            post '/graphql', params: { query: mutation, variables: variables }, headers: { 'Authorization' => ENV['API_ACCESS_TOKEN'], 'X-Store-Domain' => store2.domain  }
            json_response = JSON.parse(response.body)

            expect(json_response['data']['createAppointment']).to match(
              'appointment' => nil,
              'errors' => ['Invalid appointment']
            )
          end
        end
      end
    end
  end
end
