class FilterSpamJob < ApplicationJob
  queue_as :default

  def parse_submission(submission, http_headers)
    method_name = 'comment-check'

    response = invoke(submission, http_headers, method_name)

    unless %w{ true false }.include?(response.body)
      raise_with_response response
    end

    submission.update! headers: http_headers

    if response.body == 'true'
      submission.update! filter_result: :spam
    elsif response.body == 'true' && response['X-akismet-pro-tip'] == 'discard'
      submission.update! filter_result: :spam
    else
      submission.update! filter_result: :not_spam
    end

  end

  def perform(submission, request)
    parse_submission(submission, request)
  end
end
