$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "user_defined_attributes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_defined_attributes"
  s.version     = UserDefinedAttributes::VERSION
  s.authors     = ["John Kamenik", "Zach Rowe"]
  s.email       = ["jkamenik@waterfallsoftware.com", "zrowe@waterfallsoftware.com"]
  s.homepage    = "https://github.com/WaterfallFMS/user_defined_attributes"
  s.summary     = "Allows users to add custom attributes to a model."
  s.description = "."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 2.14.1"
end
