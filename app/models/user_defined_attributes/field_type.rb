module UserDefinedAttributes
  class FieldType < ActiveRecord::Base
    has_many :fields, :dependent => :destroy

    default_scope { where(tenant_id: Tenant.current_tenant.id) }
    
    validates :name,       presence: true, uniqueness: {scope: [:tenant_id, :model_type]}
    validates :model_type, presence: true, inclusion: {in: Config.models}
    validates :data_type,  presence: true, inclusion: {in: Config.data_types.collect{|type| type.to_s}}

    scope :sorted, lambda { order(:model_type).order('lower(name)') }
    
    
    def string?
      data_type.to_s == 'string'
    end
    
    def text?
      data_type.to_s == 'text'
    end
  end
end
