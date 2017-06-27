class SubmitSpamJob < ApplicationJob
  queue_as :default

  def submit_spam(submission)
    method_name = 'submit-spam'
    http_headers = submission.headers

    response = invoke(submission, http_headers, method_name)
    
    unless response.body == 'Thanks for making the web a better place.'
      raise_with_response response
    end
  end

  def perform(submission)
    submit_spam(submission)
  end
end
