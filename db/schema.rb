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

ActiveRecord::Schema.define(version: 20131121153951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "iec60751_prts", force: true do |t|
    t.string   "name"
    t.float    "r0",         default: 100.0
    t.float    "a",          default: 0.0039083
    t.float    "b",          default: -5.775e-07
    t.float    "c",          default: -4.183e-12
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "its90_prts", force: true do |t|
    t.string   "name"
    t.integer  "sub_range"
    t.float    "rtpw",       default: 25.0
    t.float    "a",          default: 0.0
    t.float    "b",          default: 0.0
    t.float    "c",          default: 0.0
    t.float    "d",          default: 0.0
    t.float    "w660",       default: 0.0
    t.float    "c1",         default: 0.0
    t.float    "c2",         default: 0.0
    t.float    "c3",         default: 0.0
    t.float    "c4",         default: 0.0
    t.float    "c5",         default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: true do |t|
    t.float    "value"
    t.string   "unit"
    t.string   "quantity"
    t.string   "type"
    t.integer  "instrument_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurements", ["instrument_id"], name: "index_measurements_on_instrument_id", using: :btree

end
