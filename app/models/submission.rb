class Submission < ApplicationRecord
  serialize :content
  store_accessor :content, :body, :phone, :sent_to, :headers

  enum sent_to: [:solis, :mazza, :peaking, :dev]

  validates :email, presence: true
end
