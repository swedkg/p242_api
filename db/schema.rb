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

ActiveRecord::Schema.define(version: 20190916134110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fullfilments", force: :cascade do |t|
    t.bigint "request_id"
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_fullfilments_on_request_id"
    t.index ["user_id"], name: "index_fullfilments_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "timestamp"
    t.text "message"
    t.bigint "fullfilment_id"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fullfilment_id"], name: "index_messages_on_fullfilment_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.float "lat"
    t.float "lng"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.boolean "isOneTime"
    t.index ["owner_id"], name: "index_requests_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 30
    t.string "firstName"
    t.string "lastName"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "fullfilments", "requests"
  add_foreign_key "fullfilments", "users"
  add_foreign_key "messages", "fullfilments"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "requests", "users", column: "owner_id"
end
