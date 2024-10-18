# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HungryHungryHippo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Bootstrap form error handling
    ActionView::Base.field_error_proc = proc do |html_tag, _instance|
      html_tag.gsub('form-control', 'form-control is-invalid').html_safe # rubocop:disable Rails/OutputSafety
    end

    # See https://viewcomponent.org/known_issues.html#issues-resolved-by-the-optional-capture-compatibility-patch
    config.view_component.capture_compatibility_patch_enabled = true

    config.action_dispatch.rescue_responses['Sdr::Repository::NotFoundResponse'] = :not_found

    config.autoload_once_paths += Dir[Rails.root.join('app/serializers')] # rubocop:disable Rails/RootPathnameMethods
  end
end
