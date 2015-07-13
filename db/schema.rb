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

ActiveRecord::Schema.define(version: 20150713002745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "date"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "venue_id"
  end

  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "user_events", force: :cascade do |t|
    t.string   "uuid"
    t.integer  "event_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_events", ["event_id"], name: "index_user_events_on_event_id", using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "venues"
  add_foreign_key "user_events", "events"
end
