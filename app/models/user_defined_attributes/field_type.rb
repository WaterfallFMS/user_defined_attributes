  class UserDefinedAttributes::FieldType < ActiveRecord::Base
    has_many :fields, :dependent => :destroy

    default_scope { where(tenant_id: @current_tenant) }

    validates :name,       :presence => true, :uniqueness => {:scope => :model_type}
    validates :model_type, :presence => true
    validates :data_type,  :presence => true
  end
