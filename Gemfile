source "https://rubygems.org"

# Declare your gem's dependencies in user_defined_attributes.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# simulate a standard Waterfall Rails app
group :development do
  gem 'pry-rails' # better then standard IRB

  gem 'zeus', '0.13.4.pre2'
end

group :development, :test do
  gem 'simple_form'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '>= 2.14'
  gem 'rspec'
end

group :test do
  gem 'capybara-webkit', '>= 1.0.0'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end
