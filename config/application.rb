# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eventplus
  class Application < Rails::Application
    require_relative '../lib/settings'

    config.stripe.secret_key = Settings.stripe.secret_key
    config.stripe.publishable_key = Settings.stripe.publishable_key

    config.after_initialize do
      ActionText::ContentHelper.allowed_attributes.add 'style'
    end

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/preview"
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.assets.enabled = true
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.template_engine :slim
    end
  end
end
