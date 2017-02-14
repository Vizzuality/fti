# frozen_string_literal: true
# Load the Rails application.
require_relative 'application'

require 'i18n/backend/fallbacks'
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

# Initialize the Rails application.
Rails.application.initialize!
