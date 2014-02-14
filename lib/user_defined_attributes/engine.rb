module UserDefinedAttributes
  class Engine < ::Rails::Engine
    isolate_namespace UserDefinedAttributes
    
    config.user_defined_attributes = ::UserDefinedAttributes::Config
    
    config.autoload_paths += Dir["#{config.root}/app/**/"]
  end
end
