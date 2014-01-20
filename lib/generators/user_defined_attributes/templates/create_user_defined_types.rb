class CreateUserDefinedTypes < ActiveRecord::Migration
  def self.change
    create_table :user_defined_types do |t|
      t.string   "name",                          :null => false
      t.string   "model_type",                    :null => false
      t.string   "data_type",                     :null => false
      t.boolean  "required",   :default => false, :null => false
      t.boolean  "public",     :default => false, :null => false

      t.timestamps
    end

    add_index :user_defined_types, [:name, :model_type], :unique => true
  end

end