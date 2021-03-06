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

ActiveRecord::Schema.define(version: 20140104205926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "iec60584_functions", force: true do |t|
    t.string   "name",                     null: false
    t.string   "type",                     null: false
    t.float    "a3",         default: 0.0, null: false
    t.float    "a2",         default: 0.0, null: false
    t.float    "a1",         default: 0.0, null: false
    t.float    "a0",         default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iec60584_functions", ["name"], name: "index_iec60584_functions_on_name", unique: true, using: :btree

  create_table "iec60751_functions", force: true do |t|
    t.string   "name",                            null: false
    t.float    "r0",         default: 100.0,      null: false
    t.float    "a",          default: 0.0039083,  null: false
    t.float    "b",          default: -5.775e-07, null: false
    t.float    "c",          default: -4.183e-12, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iec60751_functions", ["name"], name: "index_iec60751_functions_on_name", unique: true, using: :btree

  create_table "its90_functions", force: true do |t|
    t.string   "name",                      null: false
    t.integer  "sub_range",                 null: false
    t.float    "rtpw",       default: 25.0, null: false
    t.float    "a",          default: 0.0,  null: false
    t.float    "b",          default: 0.0,  null: false
    t.float    "c",          default: 0.0,  null: false
    t.float    "d",          default: 0.0,  null: false
    t.float    "w660",       default: 0.0,  null: false
    t.float    "c1",         default: 0.0,  null: false
    t.float    "c2",         default: 0.0,  null: false
    t.float    "c3",         default: 0.0,  null: false
    t.float    "c4",         default: 0.0,  null: false
    t.float    "c5",         default: 0.0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "its90_functions", ["name"], name: "index_its90_functions_on_name", unique: true, using: :btree

  create_table "measurements", force: true do |t|
    t.float    "value",                null: false
    t.string   "unit"
    t.string   "quantity"
    t.string   "type"
    t.integer  "its90_function_id"
    t.integer  "iec60751_function_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "measurements", "iec60751_functions", name: "measurements_iec60751_function_id_fk", dependent: :restrict
  add_foreign_key "measurements", "its90_functions", name: "measurements_its90_function_id_fk", dependent: :restrict

end
