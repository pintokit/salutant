require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Salutant
  class Application < Rails::Application
    
    # Sets Rails to log to stdout, prints SQL queries
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)

    # Generate Rspec fixtures without view, helper specs and asset files
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.view_specs false # supress view specs
      g.controller_specs false # supress controller specs
      g.helper_specs false # supress helper specs
      g.stylesheets false # supress default css files
      g.javascripts false # supress default css files
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
