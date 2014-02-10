class CreateUserDefinedAttributesFieldTypes < ActiveRecord::Migration
  def change
    create_table :user_defined_attributes_field_types do |t|
      t.integer  :tenant_id
      t.string   :name,                       null: false
      t.string   :model_type,                 null: false
      t.string   :data_type,                  null: false
      t.boolean  :required,   default: false, null: false
      t.boolean  :public,     default: false, null: false
      t.boolean  :hidden,     default: false, null: false

      t.timestamps
    end

    add_index :user_defined_attributes_field_types,
              [:name, :model_type, :tenant_id],
              unique: true, name: 'udaft_unique'
  end

end