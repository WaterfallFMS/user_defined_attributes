module UserDefinedAttributes
  module UdaHelper
    def uda_field_name(f,key)
      %Q(#{f.object_name}[fields[#{key}]])
    end

    def uda_field_id(f,key)
      %Q(#{f.object_name}_fields_#{key})
    end

    def render_uda_in_form(form)
      render partial: 'user_defined_attributes/form', locals: {f: form}
    end

    def render_uda_fields_for(object)
      render partial: 'user_defined_attributes/show', locals: {object: object}
    end
  end
end