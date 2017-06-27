class ApplicationJob < ActiveJob::Base
  def invoke(submission, http_headers, method_name)
    uri = generate_uri_for(method_name)
    remote_ip, user_agent, referer = retrieve_request(http_headers)

    message = { blog: app_url, user_ip: remote_ip, user_agent: user_agent, referrer: referer, comment_type: 'contact-form', comment_author: submission.name, comment_author_email: submission.email, comment_content: submission.content, comment_date_gmt: submission.created_at, blog_lang: 'en', blog_charset: 'UTF-8', env: http_headers}

    post_parameters = URI.encode_www_form(message)

    response = Net::HTTP.start( uri.host, uri.port, use_ssl: :true) do |http|
      http.post(uri, post_parameters, app_http_headers)
    end

    unless response.is_a?( Net::HTTPOK )
      raise Error, "HTTP #{ response.code } received (expected 200)"
    end

    return response
  end

  def app_http_headers
    {
      'User-Agent' => "Salutant/#{Rails.version} | #{ENV['AKISMET_VERSION']}",
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
  end

  def generate_uri_for(method_name)
    URI("https://#{ENV['AKISMET_API_KEY']}.rest.akismet.com/1.1/#{method_name}")
  end

  def app_url
    "http://#{ENV['APP_DOMAIN']}"
  end

  def retrieve_request(env)
    return env['REMOTE_ADDR'], env['HTTP_USER_AGENT'], env['HTTP_REFERER']
  end

end
