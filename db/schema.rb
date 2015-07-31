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

ActiveRecord::Schema.define(version: 20150731122301) do

  create_table "calendar_accesses", force: :cascade do |t|
    t.integer  "user_calendar_id", limit: 4
    t.integer  "user_id",          limit: 4
    t.string   "color",            limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "access_level",     limit: 255
  end

  create_table "event_sets", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "description",      limit: 65535
    t.integer  "instances",        limit: 4
    t.integer  "duration",         limit: 4
    t.integer  "period",           limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "start_at"
    t.integer  "user_calendar_id", limit: 4
    t.string   "interval_units",   limit: 255,   default: "DAYS"
    t.boolean  "has_end",          limit: 1,     default: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "notes",              limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "event_set_id",       limit: 4
    t.integer  "event_set_instance", limit: 4
    t.integer  "user_calendar_id",   limit: 4
  end

  create_table "user_calendars", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "color",       limit: 255
    t.string   "visibility",  limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",                 null: false
    t.string   "encrypted_password",     limit: 255, default: "",                 null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,                  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "snap_to_minutes",        limit: 4,   default: 15
    t.string   "timezone",               limit: 255, default: "America/New_York"
    t.integer  "default_calendar_id",    limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
