require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
Bundler.require(*Rails.groups)
module VbaTicketing
  class Application < Rails::Application
    config.assets.quiet = true
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => '*'
    }
    config.cache_store = :redis_store, ENV['CACHE_URL'], { expires_in: 90.minutes }
    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
      generate.jbuilder false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.active_job.queue_adapter = :sidekiq

    config.to_prepare do
      Devise::SessionsController.layout 'blank'
    end

    config.time_zone = 'Hanoi'
  end
end
