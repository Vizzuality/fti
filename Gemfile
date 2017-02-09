# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'pg',    '~> 0.18'
gem 'rails', '~> 5.0-stable'

# Assets managment
gem 'coffee-rails', '~> 4.2'
gem 'gon'
gem 'jbuilder',     '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
gem 'sass-rails',   '~> 5.0'
gem 'slim-rails'
gem 'turbolinks',   '~> 5'
gem 'uglifier',     '>= 1.3.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-foundation'
end

gem 'cancancan'
gem 'country_select'
gem 'devise'
gem 'kaminari'
gem 'simple_form'

group :development, :test do
  gem 'byebug',                platform: :mri
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rspec-activejob'
  gem 'rspec-rails'
  gem 'rubocop',               require: false
  gem 'webmock'
end

group :development do
  gem 'annotate'
  gem 'brakeman',              require: false
  gem 'listen',                '~> 3.0.5'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'bullet'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'timecop'
end

# Server
gem 'puma'
gem 'rails_12factor', group: :production
gem 'tzinfo-data'
