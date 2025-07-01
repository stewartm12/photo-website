class AdminController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch['MISSION_CONTROL_USERNAME'], password: ENV.fetch('MISSION_CONTROL_PASSWORD')
end
