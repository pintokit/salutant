class Submission < ApplicationRecord
  include Rakismet::Model

  serialize :content
  store_accessor :content, :body, :phone
  rakismet_attrs :comment_type => "contact-form"
end
