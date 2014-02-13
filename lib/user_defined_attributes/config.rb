module UserDefinedAttributes
  class Config
    class << self
      # models ([])- Model names that can have UDA
      #
      # We constantize the name and use "model_name.human" as the display value
      #
      # config.models = ['Location']
      attr_accessor :models
      
      # data_types ([]) - Array of data type symbols, in case you want to disable any of them.
      #
      # valid values:
      #  1. :string - 255 characters or less
      #  2. :text   - Infinite length text
      # 
      # config.data_types = [:string, :text]
      attr_accessor :data_types
      
      # default_data_type (symbol) - Which data type is default selected type
      # 
      # config.default_data_type = :string
      attr_accessor :default_data_type
      
      # form_builder (:action_view) - Name of form builder to use
      #
      # config.form_builder = :simple_form
      attr_accessor :form_builder
      
      def init!
        @defaults = {
          :@models            => [],
          :@data_types        => [:string, :text],
          :@default_data_type => :string,
          :@form_builder      => :action_view
        }
      end
      
      def reset!
        @defaults.each do |key,value|
          instance_variable_set(key,value)
        end
      end
      
      def configure(&block)
        block.call(self)
      end
      
      def models_display
        models.collect do |model|
          [model.constantize.model_name.human,model]
        end
      end
    end
    
    init!
    reset!
  end
end