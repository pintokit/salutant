Puma::Plugin.create do
  def config(c)

    threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
    c.threads threads_count, threads_count

    c.preload_app!

    c.port        ENV.fetch("PORT") { 5000 }
    c.environment ENV.fetch("RAILS_ENV") { "development" }

    if workers_supported?
      c.workers ENV.fetch("WEB_CONCURRENCY") { 2 }

      c.before_fork do
        ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
      end
      c.on_worker_boot do
        ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
      end
    end
  end

  VERSION = "1.0.0"
end
