module UserDefinedAttributes
  # NestedFormFields is used by field_for to calculate values of any existing UDA values
  #
  # We also proxy the errors object so that the fields correctly error
  class NestedFormFields < OpenStruct
    attr_reader :object
    
    def initialize(object)
      super object.fields
      @object = object
    end
    
    def errors
      @errors ||= NestedErrorProxy.new object
    end
    
    # NestedErrorProxy proxies to the error object and translates any error 
    # calculation to the correct namespace.  Everything else gets delegated directly
    # to the base's errors object.
    class NestedErrorProxy
      attr_reader :object, :errors
      
      def initialize(object)
        @object = object
        @errors = object.errors
      end
      
      def [](key)
        # field errors are nested under "fields."
        nested_key = "fields.#{key}".to_sym
        
        @errors[nested_key]
      end
      
      private
      
      def method_missing(method,*args,&block)
        errors.public_send(method,*args,&block)
      end
      
      def respond_to_missing?(method, include_private = false)
        errors.respond_to?(method,include_private)
      end
    end
  end
end