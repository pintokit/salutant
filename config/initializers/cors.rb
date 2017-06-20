Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*.davidsolis.me, *.davidmazza.com, *.soliskit.com, *herokuapp.com, localhost:5000'
    resource '/submissions',
      headers: :any,
      methods: %i(post)
  end
end
