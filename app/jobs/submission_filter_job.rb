class SubmissionFilterJob < ApplicationJob
  queue_as :default

  def parse_submission(submission, request)

    api_key = ENV['AKISMET_API_KEY']
    app_url = "http://#{ENV['APP_DOMAIN']}"
    http_headers = { 'User-Agent' => "Salutant/1.0 | #{ENV['AKISMET_VERSION']}", 'Content-Type' => 'application/x-www-form-urlencoded' }
    method_name = 'comment-check'

    uri = URI("https://#{api_key}.rest.akismet.com/1.1/#{method_name}")

    message = { blog: app_url, user_ip: request.remote_ip, user_agent: request.user_agent, referrer: request.referer, comment_type: 'contact-form', comment_author: submission.name, comment_author_email: submission.email, comment_content: submission.content, comment_date_gmt: submission.created_at, blog_lang: 'en', blog_charset: 'UTF-8' }

    post_parameters = URI.encode_www_form(message)

    response = Net::HTTP.start( uri.host, uri.port, use_ssl: :true) do |http|
      http.post(uri, post_parameters, http_headers)
    end

    case response
    when Net::HTTPRedirection
      print 'Failed to check submission because the remote server issued a redirect'
    when Net::HTTPSuccess

      unless %w{ true false }.include?(response.body)
        print "#{response.error!}"
      end

      if response.body == 'true'
        submission.update! filter_result: :spam
      elsif response.body == 'true' && response['X-akismet-pro-tip'] == 'discard'
        submission.update! filter_result: :spam
      else
        submission.update! filter_result: :not_spam
      end

    else # failed to receive response code 200
      print "#{response.error!}"
    end

  end

  def perform(submission, request)
    parse_submission(submission, request)
  end
end
