require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module UserDefinedAttributes
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)
    
    class_option :skip_migrations, :optional => true, :type => :boolean,
                 :desc => 'Skip copying of the migration files'
    class_option :skip_initializer, :optional => true, :type => :boolean,
                 :desc => 'Skip copying of the initializer'
    class_option :skip_controller, :optional => true, :type => :boolean,
                 :desc => 'Skip generating the controller'

    def create_migration_file
      return if options[:skip_migrations]
      
      migration_template 'create_user_defined_attributes_fields.rb', 'db/migrate/create_user_defined_attributes_fields.rb'
      migration_template 'create_user_defined_attributes_field_types.rb', 'db/migrate/create_user_defined_attributes_field_types.rb'
    end
    
    def create_initializer
      return if options[:skip_initializer]
      
      template 'initializer.rb', 'config/initializers/user_defined_attributes.rb'
    end
    
    def create_controller
      return if options[:skip_controller]
      
      route = <<EOF
  namespace :user_defined_attributes do
    resources :field_types, except: :show
  end
EOF
      
      generate 'scaffold_controller', 'UserDefinedAttributes::FieldType'
      copy_file 'field_types_controller.rb', 'app/controllers/user_defined_attributes/field_types_controller.rb', force: true
      copy_file 'field_types_form.erb', 'app/views/user_defined_attributes/field_types/_form.html.erb', force: true
      inject_into_file 'config/routes.rb', route, :after => 'routes.draw do'
    end
    
    private

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end