class Submission < ApplicationRecord
  serialize :content
  store_accessor :content, :body, :phone

  enum filter_result: [:spam, :not_spam]

  validates :email, presence: true
end
