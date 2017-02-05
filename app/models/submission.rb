class Submission < ApplicationRecord
  serialize :content
  store_accessor :content, :body, :phone
end
