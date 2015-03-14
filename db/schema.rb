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

ActiveRecord::Schema.define(version: 20150314221316) do

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

  create_table "dances", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "name"
    t.uuid   "dance_id"
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
    t.string "type"
    t.string "name"
  end

  create_table "events", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "type"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.uuid     "place_id",       null: false
    t.uuid     "event_group_id", null: false
  end

  add_index "events", ["place_id"], name: "index_events_on_place_id", using: :btree

  create_table "places", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.uuid   "place_id"
    t.string "description"
  end

  add_index "places", ["place_id"], name: "index_places_on_place_id", using: :btree

  create_table "relation_ships", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type"
    t.uuid   "user_id",        null: false
    t.uuid   "event_id"
    t.uuid   "event_group_id"
  end

  add_index "relation_ships", ["event_group_id"], name: "index_relation_ships_on_event_group_id", using: :btree
  add_index "relation_ships", ["event_id"], name: "index_relation_ships_on_event_id", using: :btree
  add_index "relation_ships", ["user_id"], name: "index_relation_ships_on_user_id", using: :btree

  create_table "roles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string "type"
    t.uuid   "user_id", null: false
  end

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

end
