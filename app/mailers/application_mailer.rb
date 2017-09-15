class ApplicationMailer < ActionMailer::Base
  default from: ENV['REPLY_TO']
  layout 'mailer'

  def new_message_notification(submission)
    @submission = submission

    if @submission.content['sent_to'] == :mazza
      @addressed_to = "David Mazza <hello@peaking.co>"
    else
      @addressed_to = "David Solis <hola@peaking.co>"
    end

    if @submission.name.blank?
      @name = "Name Not Provided"
      @email = @submission.email
    else
      @name = @submission.name
      @email = %("#{@name}" <#{@submission.email}>)
    end

    mail from: @email, to: @addressed_to, subject: "New Email From #{@name}", body: @submission.content['body']
  end
end
