require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  it 'successfully connects with a valid session cookie' do
    cookies.signed[:session_id] = session.id

    connect '/cable'

    expect(connection.current_user).to eq(user)
  end

  it 'rejects connection without a valid session' do
    expect {
      connect '/cable'
    }.to raise_error(ActionCable::Connection::Authorization::UnauthorizedError)
  end
end
