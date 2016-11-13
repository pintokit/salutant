class Submission < ApplicationRecord
  serialize :content, HashSerializer
  store_accessor :content, :body, :phone
end
