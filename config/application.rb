require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SaPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    aws_akia = (Rails.application.credentials.dig(:aws, :access_key_id) || ENV['AWS_ACCESS_KEY'])
    aws_secret = (Rails.application.credentials.dig(:aws, :secret_access_key) || ENV['AWS_SECRET_KEY'])
    
    Aws.config.update(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(aws_akia, aws_secret)
    )

    config.time_zone = 'London'  # e.g., 'London', 'Eastern Time (US & Canada)', etc.
    config.active_record.default_timezone = :local  # This ensures ActiveRecord uses the local timezone

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
