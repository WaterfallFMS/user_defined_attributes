# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140206142418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leads", force: true do |t|
    t.integer "tenant_id"
    t.string  "name"
    t.string  "email"
  end

  create_table "user_defined_attributes_field_types", force: true do |t|
    t.integer  "tenant_id"
    t.string   "name",                       null: false
    t.string   "model_type",                 null: false
    t.string   "data_type",                  null: false
    t.boolean  "required",   default: false, null: false
    t.boolean  "public",     default: false, null: false
    t.boolean  "hidden",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_defined_attributes_field_types", ["name", "model_type", "tenant_id"], name: "udaft_unique", unique: true, using: :btree

  create_table "user_defined_attributes_fields", force: true do |t|
    t.integer  "tenant_id"
    t.integer  "field_type_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_defined_attributes_fields", ["field_type_id", "model_type", "tenant_id"], name: "udaf_unique", unique: true, using: :btree
  add_index "user_defined_attributes_fields", ["model_type", "model_id", "tenant_id"], name: "udaf_model", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
