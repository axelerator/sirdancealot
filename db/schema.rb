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

ActiveRecord::Schema.define(version: 20150415161625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "authentications", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "conversations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dances", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "dance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dances", ["dance_id"], name: "index_dances_on_dance_id", using: :btree

  create_table "dances_event_groups", id: false, force: :cascade do |t|
    t.uuid "event_group_id", null: false
    t.uuid "dance_id",       null: false
  end

  add_index "dances_event_groups", ["dance_id"], name: "index_dances_event_groups_on_dance_id", using: :btree
  add_index "dances_event_groups", ["event_group_id"], name: "index_dances_event_groups_on_event_group_id", using: :btree

  create_table "dances_events", id: false, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "dance_id", null: false
  end

  add_index "dances_events", ["dance_id"], name: "index_dances_events_on_dance_id", using: :btree
  add_index "dances_events", ["event_id"], name: "index_dances_events_on_event_id", using: :btree

  create_table "event_groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string  "type"
    t.string  "name"
    t.date    "start_day",  null: false
    t.date    "end_day",    null: false
    t.integer "start_time", null: false
    t.integer "duration"
    t.text    "schedule"
  end

  add_index "event_groups", ["type"], name: "index_event_groups_on_type", using: :btree

  create_table "events", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "type"
    t.datetime "starts_at",      null: false
    t.datetime "ends_at",        null: false
    t.uuid     "place_id",       null: false
    t.uuid     "event_group_id", null: false
  end

  add_index "events", ["event_group_id"], name: "index_events_on_event_group_id", using: :btree
  add_index "events", ["place_id"], name: "index_events_on_place_id", using: :btree
  add_index "events", ["type"], name: "index_events_on_type", using: :btree

  create_table "institutions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
  end

  add_index "institutions", ["type"], name: "index_institutions_on_type", using: :btree

  create_table "messages", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "body",            null: false
    t.uuid     "conversation_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "description"
  end

  add_index "places", ["type"], name: "index_places_on_type", using: :btree

  create_table "relationships", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string  "type"
    t.uuid    "user_id"
    t.uuid    "event_id"
    t.uuid    "place_id"
    t.uuid    "event_group_id"
    t.uuid    "institution_id"
    t.uuid    "message_id"
    t.uuid    "conversation_id"
    t.uuid    "hosted_by_institution_id"
    t.integer "state"
  end

  add_index "relationships", ["conversation_id"], name: "index_relationships_on_conversation_id", using: :btree
  add_index "relationships", ["event_group_id"], name: "index_relationships_on_event_group_id", using: :btree
  add_index "relationships", ["event_id"], name: "index_relationships_on_event_id", using: :btree
  add_index "relationships", ["hosted_by_institution_id"], name: "index_relationships_on_hosted_by_institution_id", using: :btree
  add_index "relationships", ["institution_id"], name: "index_relationships_on_institution_id", using: :btree
  add_index "relationships", ["message_id"], name: "index_relationships_on_message_id", using: :btree
  add_index "relationships", ["place_id"], name: "index_relationships_on_place_id", using: :btree
  add_index "relationships", ["type"], name: "index_relationships_on_type", using: :btree
  add_index "relationships", ["user_id"], name: "index_relationships_on_user_id", using: :btree

  create_table "roles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type"
    t.uuid   "user_id", null: false
  end

  add_index "roles", ["type"], name: "index_roles_on_type", using: :btree
  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "crypted_password",             null: false
    t.string   "salt",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

  add_foreign_key "events", "event_groups"
  add_foreign_key "events", "places"
  add_foreign_key "messages", "conversations"
  add_foreign_key "relationships", "conversations"
  add_foreign_key "relationships", "event_groups"
  add_foreign_key "relationships", "events"
  add_foreign_key "relationships", "institutions"
  add_foreign_key "relationships", "institutions", column: "hosted_by_institution_id"
  add_foreign_key "relationships", "messages"
  add_foreign_key "relationships", "places"
  add_foreign_key "relationships", "users"
end
