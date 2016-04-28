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

ActiveRecord::Schema.define(version: 20160427201847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token_id"
    t.integer  "points"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "scoreable_type"
    t.integer  "scoreable_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                            null: false
    t.integer  "user_id",                         null: false
    t.text     "notes"
    t.integer  "interest",            default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "website"
    t.string   "blog"
    t.string   "address"
    t.decimal  "glassdoor_rating"
    t.string   "glassdoor_website"
    t.string   "glassdoor_logo_link"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title",              null: false
    t.string   "application_status"
    t.string   "url"
    t.integer  "company_id",         null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "notes"
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "company_id", null: false
    t.string   "name",       null: false
    t.string   "linked_in"
    t.string   "blog"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  add_index "leads", ["company_id"], name: "index_leads_on_company_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id",                             null: false
    t.datetime "start_date",                          null: false
    t.string   "recommendable_type",                  null: false
    t.integer  "recommendable_id",                    null: false
    t.string   "action",                              null: false
    t.boolean  "completed",          default: false,  null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "query"
    t.string   "field"
    t.string   "kind"
    t.string   "label",              default: "edit"
    t.string   "link"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.string   "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_onboarded"
    t.string   "default_location"
    t.string   "default_keyword"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "leads", "companies"
  add_foreign_key "recommendations", "users"
end
