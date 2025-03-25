class ApplicationMailer < ActionMailer::Base
  default from: ENV['NO_REPLY_EMAIL']
  layout 'mailer'
end
