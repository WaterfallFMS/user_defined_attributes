module UserDefinedAttributes
  class Field < ActiveRecord::Base
    default_scope { where(tenant_id: Tenant.current_tenant.id) }

    belongs_to :field_type
    belongs_to :model, :polymorphic => true
    
    delegate :required?, :string?, :text?, to: :field_type
    
    validates :value, presence: true, if: :required?
    validates :value, length: {maximum: 255}, allow_blank: true, if: :string?
  end
end
