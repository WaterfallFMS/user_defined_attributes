require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'webmock/rspec'
#require 'pundit/rspec'
#require 'user_defined_attributes'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| p file; require file }

module Features
  # Extend this module in spec/support/features/*.rb
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  #config.fail_fast = true
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = true
  config.order = 'random'
  config.use_transactional_fixtures = false
end

Capybara.javascript_driver = :webkit
WebMock.disable_net_connect!(allow_localhost: true)
