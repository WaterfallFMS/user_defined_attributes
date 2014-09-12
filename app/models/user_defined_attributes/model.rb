module UserDefinedAttributes
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :user_defined_fields, :as => :model, :dependent => :destroy, :class_name => 'UserDefinedAttributes::Field'
      after_save      :set_user_defined_fields
      before_validation :check_fields
    end

    class Attribute
      attr_reader   :type, :name, :uda, :model_type
      attr_accessor :value

      def initialize(uda,value=nil)
        @uda        = uda
        @model_type = uda.model_type
        @name       = uda.name
        @type       = uda.data_type
        @required   = uda.required?
        @public     = uda.public?
        @hidden     = uda.hidden?
        self.value  = value
      end

      def to_s
        @value.to_s
      end
      def inspect
        %Q(<#{self.class.name} @name="#{name}" @type="#{type}" @value="#{value}" @require="#{required?}" @public="#{public?}" @hidden="#{hidden?}">)
      end

      def required?
        @required
      end
      def blank?
        @value.blank?
      end
      def public?
        @public
      end
      def hidden?
        @hidden
      end

      def ==(other)
        @value == other
      end
      def ===(other)
        @value === other
      end
    end


    module ClassMethods
      def field_types
        UserDefinedAttributes::FieldType.where(:model_type => self)
      end

      def uda_strong_params
        {
            fields: field_types.collect {|type| type.name }
        }
      end
    end

    def field_types
      self.class.field_types
    end

    def fields
      return @fields unless @fields.blank?
      set_fields_data
    end

    def fields_data
      set_fields_data
    end

    def values
      OpenStruct.new(public_fields(true))
    end

    def public_fields(all = false)
      return FieldHash.new if fields.blank?

      fields.inject(FieldHash.new) do |hash,item|
        key, value = item
        hash[liquidize(key)] = value.to_s if value.public? || all
        hash
      end
    end

    def fields=(args)
      raise ArgumentError, 'fields must be a Hash' unless args.is_a?(Hash)

      @fields_dirty = true

      # we need to remain a hash of Attribute
      @fields = FieldHash.new
      field_types.each do |type|
        @fields[type.name] = Attribute.new type, args[type.name]
      end
    end

    def check_fields
      field_types.each do |type|
        field = Field.new field_type: type, value: fields[type.name].to_s
        unless field.valid?
          field.errors.each do |attrib,error|
            # simulate an nested attribute error
            attribute = "fields.#{type.name}"
            self.errors[attribute] << error
            self.errors[attribute].uniq!
          end
        end
      end
    end

    # a hook for letting error messages work
    def read_attribute_for_validation(attribute)
      fields.fetch(attribute.to_s) {send(attribute)}
    end

    private
    def set_fields_data
      ids    = {}
      fields = FieldHash.new
      field_types.each do |type|
        fields[type.name] = Attribute.new type
        ids[type.id]      = type.name
      end
      user_defined_fields.reload.each do |field|
        fields[ids[field.field_type_id]].value = field.value
      end
      @fields=fields
    end

    def set_user_defined_fields
      return unless @fields_dirty
      return unless @fields

      user_defined_fields.destroy_all
      field_types.each do |type|
        value = @fields[type.name]
        next if value.blank?
        
        UserDefinedAttributes::Field.create :field_type => type, :model => self, :value => value.to_s
      end
    end

    def liquidize(key)
      key.gsub(' ','_').gsub(/[^a-zA-Z0-9_]/,'')
    end
  end
end