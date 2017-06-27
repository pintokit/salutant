class ApplicationMailer < ActionMailer::Base
  default from: ENV['REPLY_TO']
  layout 'mailer'
end
