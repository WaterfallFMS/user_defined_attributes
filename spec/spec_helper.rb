require 'rubygems'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include FactoryGirl::Syntax::Methods
end
