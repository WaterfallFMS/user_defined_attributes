module UserDefinedAttributes
  class Field < ActiveRecord::Base
    default_scope { where(tenant_id: Tenant.current_tenant.id) }

    belongs_to :field_type
    belongs_to :model, :polymorphic => true
  end
end
