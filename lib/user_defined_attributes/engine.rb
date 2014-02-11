module UserDefinedAttributes
  autoload :FieldTypesController, File.expand_path('../../../app/controllers/user_defined_attributes/field_types_controller',__FILE__)
  
  class Engine < ::Rails::Engine
    isolate_namespace UserDefinedAttributes
    
    config.autoload_paths += Dir["#{config.root}/app/**/"]
  end
end
