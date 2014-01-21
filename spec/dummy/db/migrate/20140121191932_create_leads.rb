class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.integer :tenant_id
      t.string :name
      t.string :email
    end
  end
end
