class Submission < ApplicationRecord
  serialize :content
  store_accessor :content, :sent_to, :body, :phone

  enum filter_result: [:discard, :spam, :not_spam]

  validates :email, presence: true
end
