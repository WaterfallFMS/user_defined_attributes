class CreateUserDefinedFields < ActiveRecord::Migration
  def self.change
    create_table :user_defined_fields do |t|
      t.belongs_to :user_defined_type
      t.belongs_to :model, :polymorphic => true
      t.text       :value
      t.string     :model_type
      t.integer    :tenant_id

      t.timestamps
    end

    add_index :user_defined_fields, [:model_type, :model_id]
    add_index :user_defined_fields, [:user_defined_type_id, :model_type], :unique => true,
              :name => 'udf_unique'
  end
end
