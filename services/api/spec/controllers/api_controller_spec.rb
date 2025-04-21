require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  it 'inherits from ActionController::API' do
    expect(ApiController).to be < ActionController::API
  end
end
