source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem 'active_model_serializers'
gem "bootsnap", require: false
gem "concurrent-ruby", "1.3.4" 
gem "bcrypt", "~> 3.1.7"
gem "config"
gem "importmap-rails"
gem "jbuilder"
gem 'karafka'
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "stripe"
gem "rails", "7.0.5"
gem "redis"
gem "faker"
gem "sprockets-rails"
gem "stimulus-rails"
gem "rack-cors"
gem "turbo-rails"
gem "dotenv-rails", groups: [:development, :test]
gem "jwt"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
