class Submission < ApplicationRecord
  serialize :content
  store_accessor :content, :sent_to, :body, :phone, :headers

  enum sent_to: [:solis, :mazza, :peaking, :dev]

  validates :email, presence: true
end
