source 'https://rubygems.org'

ruby '2.4.2'

gem 'autoprefixer-rails'
gem 'flutie'
gem 'jquery-rails'
gem 'normalize-rails', '~> 3.0.0'
gem 'pg'
gem 'puma'
gem 'rails', '~> 5.1.1'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'nested_form'
gem 'sprockets', '>= 3.0.0'
gem 'uglifier'
gem 'slim-rails'
gem 'jbuilder'
gem 'redis-rails'

# backgroud job
gem 'sidekiq'
gem 'whenever', require: false

# csv process
gem 'smarter_csv'
gem 'rubyzip'
# phone number normalize
gem 'phony_rails'

# Easy file attachment management for ActiveRecord
gem 'paperclip', '~> 5.1'
# Amazon Ruby SDK for interacting with S3
gem 'aws-sdk', '~> 2'

# http request
gem 'httparty'

# bootstrap
gem 'bootstrap-sass', '~> 3.3.6'
gem 'font-awesome-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails', :git => 'https://github.com/Nerian/bootstrap-datepicker-rails.git'

# authentication
gem 'devise'
gem 'omniauth-google-oauth2'

# paginate
gem 'kaminari'

# audit
gem 'audited', '~> 4.5'

gem 'htmlentities'

# chart
gem "chartkick"

# slug
gem 'friendly_id', '~> 5.1.0'

# validate time related on active record
gem 'validates_timeliness', '~> 4.0'

# normalize active record attributes
gem 'attribute_normalizer'

# generate QR code
gem 'rqrcode'

# enumerize
gem 'enumerize'

# select2
gem 'select2-rails'

gem 'dotenv-rails'

# Ransack
gem 'ransack'

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git', require: false
  gem 'guard-rspec', require: false
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'faker'
end

group :test do
  gem 'database_cleaner'
  gem 'formulaic'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

gem 'rails_12factor', group: :production
