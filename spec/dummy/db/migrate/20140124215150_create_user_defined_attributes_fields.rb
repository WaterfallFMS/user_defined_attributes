class CreateUserDefinedAttributesFields < ActiveRecord::Migration
  def change
    create_table :user_defined_attributes_fields do |t|
      t.integer    :tenant_id
      t.belongs_to :user_defined_type
      t.belongs_to :model, :polymorphic => true
      t.text       :value
      t.string     :model_type

      t.timestamps
    end

    add_index :user_defined_attributes_fields, [:model_type, :model_id, :tenant_id], :name => 'udaf_model'
    add_index :user_defined_attributes_fields, [:user_defined_type_id, :model_type, :tenant_id], :unique => true,
              :name => 'udaf_unique'
  end
end
