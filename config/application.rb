# frozen_string_literal: true
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

module Fti
  class Application < Rails::Application
    # config.active_record.schema_format = :sql
    config.i18n.fallbacks                 = true
    config.i18n.enforce_available_locales = true
    config.i18n.fallbacks                 = { 'en' => 'fr', 'fr' => 'en' }

    config.generators do |g|
      g.test_framework  :rspec
      g.template_engine :slim
      g.view_specs      false
      g.helper_specs    false
      g.factory_girl    false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end
  end
end
