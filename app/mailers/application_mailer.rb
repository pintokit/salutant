class ApplicationMailer < ActionMailer::Base
  default from: ENV['REPLY_TO']
  layout 'mailer'

  def new_message_notification(submission)
    @submission = submission

    if @submission.content['sent_to'] == :mazza
      @addressed_to = "David Mazza <hello@peaking.co>"
      @subject = "Message On davidmazza.com"
    else
      @addressed_to = "David Solis <hola@peaking.co>"
      @subject = "Message On davidsolis.me"
    end

    if @submission.name.blank?
      @email = @submission.email
    else
      @email = %("#{@submission.name}" <#{@submission.email}>)
    end

    mail from: @email, reply_to: @email, to: @addressed_to, subject: @subject, body: @submission.content['body']
  end
end
