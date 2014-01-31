require 'rubygems'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'database_cleaner'
require 'factories/leads'
require 'factories/user_defined_attribute_factory'
require 'user_defined_attributes'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    unless example.metadata[:skip_tenant]
      @current_tenant = 1
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include FactoryGirl::Syntax::Methods
end
