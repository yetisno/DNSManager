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

ActiveRecord::Schema.define(version: 20150128180332) do

  create_table "as", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name"
    t.string   "to_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cnames", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name"
    t.string   "to_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "mxes", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name"
    t.integer  "priority"
    t.string   "to_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nameservers", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name"
    t.string   "to_ns"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ptrs", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "ip_arpa"
    t.string   "to_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "soas", force: :cascade do |t|
    t.integer  "domain_id"
    t.string   "name"
    t.string   "contact"
    t.integer  "serial"
    t.integer  "refresh"
    t.integer  "retry"
    t.integer  "expire"
    t.integer  "minimum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_domain_maps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
