require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module UserDefinedAttributes
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)
    
    class_option :skip_migrations, :optional => true, :type => :boolean,
                 :desc => 'Skip copying of the migration files'

    desc 'Generates migrations.'
    def create_migration_file
      return if options[:skip_migrations]
      
      migration_template 'create_user_defined_attributes_fields.rb', 'db/migrate/create_user_defined_attributes_fields.rb'
      migration_template 'create_user_defined_attributes_field_types.rb', 'db/migrate/create_user_defined_attributes_field_types.rb'
    end
    
    desc 'Generate initializer'
    def create_initializer
      template 'initializer.rb', 'config/initializers/user_defined_attributes.rb'
    end
    
    private

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end