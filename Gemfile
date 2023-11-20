source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

#
# Added gems
#

# ActiveRecord::JSONValidator makes it easy to validate JSON attributes against a JSON schema.
gem 'activerecord_json_validator'
# Extensions to make postgres accept unaccent strings
gem 'arel_extensions'
# Interact with Amazon S3 Buckets
gem 'aws-sdk'
# Brazilian States
gem 'brazilian_states', git: 'https://github.com/ArthurFerraz07/brazilian_states.git'
# Current available solutions to find Brazilian addresses by zipcode
gem 'correios-cep'
# Checks valid CPNJ and CPF
gem 'cpf_cnpj'
# Change data on the database using data migrations
gem 'data_migrate'
# Authentication
gem 'devise'
# Devise API authentication
gem 'devise_token_auth'
# Use .env files to automatically load environment variables
gem 'dotenv-rails'
# Fixtures replacement with a straightforward definition syntax
gem 'factory_bot_rails', require: false
# A library for generating fake data such as names, addresses, and phone numbers.
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'
# This gem allows you to easily use Hashids in your Rails app. Instead of your models using sequential numbers like 1, 2, 3, they will instead have unique short hashes like "yLA6m0oM", "5bAyD0LO", and "wz3MZ49l".
gem 'hashid-rails', '~> 1.0'
# Log outgoing HTTP requests made from your application.
gem 'httplog'
# HTTParty
gem 'httparty'
# Pagination
gem 'kaminari'
# Dealing with Money in Rails Apps
gem 'money-rails'
# Authorization
gem 'pundit'
# Runtime developer console
gem 'pry'
# Fixing the http-parser gem version to work on M1 Macs
gem 'http-parser', '~> 1.2.3'
# Admin
gem "administrate"
# Search
gem 'pg_search'
# Swagger for docs
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # A set of RSpec matchers for testing Pundit authorisation policies
  gem 'pundit-matchers', '~> 1.6.0'
  # rspec-rails brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework, Minitest
  gem 'rspec-rails'
  # Static code analyzer and code formatter
  gem 'rubocop', require: false
  # Swagger tests
  gem 'rswag-specs'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  # Shoulda Matchers provides RSpec and Minitest compatible one-liners to test
  gem 'shoulda-matchers'
  # SimpleCov is a code coverage analysis tool for Ruby.
  gem 'simplecov', require: false
end
gem "sassc-rails"
