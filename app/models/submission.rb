class Submission < ApplicationRecord
  include Rakismet::Model

  serialize :content
  store_accessor :content, :body, :phone
  rakismet_attrs comment_type: :contact_form, user_ip: :user_ip, user_agent: :user_agent, referrer: :referrer

  enum filter_result: [:spam, :not_spam]
end
