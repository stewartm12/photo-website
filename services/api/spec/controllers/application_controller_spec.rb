require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'inherits from ActionController::API' do
    expect(ApplicationController).to be < ActionController::API
  end
end
