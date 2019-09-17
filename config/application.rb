require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MnoEnterpriseDemo
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.view_specs false
      g.helper_specs false
    end

    config.action_mailer.delivery_method = :smtp

    # This is replaced with Settings.system.smtp_settings after initialization
    config.action_mailer.smtp_settings = {
      authentication: :plain,
      address: ENV['SMTP_HOST'],
      port: ENV['SMTP_PORT'],
      domain: ENV['SMTP_DOMAIN'],
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD']
    }

    # Cache Store
    config.cache_store = if ENV['REDIS_URL'].present?
                           [:redis_store, File.join(ENV['REDIS_URL'], 'cache')]
                         else
                           :memory_store
                         end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Use Sucker Punch for ActiveJob
    config.active_job.queue_adapter = :sucker_punch
  end
end
