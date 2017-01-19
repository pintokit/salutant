json.extract! submission, :id, :name, :email, :content, :created_at, :updated_at
json.url submission_url(submission, format: :json)
