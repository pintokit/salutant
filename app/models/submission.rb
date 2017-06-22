class Submission < ApplicationRecord
  include Rakismet::Model

  serialize :content
  store_accessor :content, :body, :phone

  enum filter_result: [:spam, :not_spam]

  def store(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.user_agent
    self.referrer = request.referer
  end
end
