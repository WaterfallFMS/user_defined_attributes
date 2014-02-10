# having trouble finding factories so load manually
Dir[File.expand_path('../../factories/**/*.rb', __FILE__)].each { |file| require file }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
