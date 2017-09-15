class NewMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(submission)
    ApplicationMailer.new_message_notification(submission).deliver_later
  end
end
