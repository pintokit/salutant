class Submission < ApplicationRecord
  include Rakismet::Model

  serialize :content
  store_accessor :content, :body, :phone

  enum filter_result: [:spam, :not_spam]
end
