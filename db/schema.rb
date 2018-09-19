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

ActiveRecord::Schema.define(version: 2018_09_18_101002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "capacity"
    t.string "picture"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_bags_on_user_id"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
  end

  create_table "item_references", force: :cascade do |t|
    t.string "name"
    t.float "size"
    t.float "weight"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_item_references_on_category_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reference_id"
    t.float "size"
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference_id"], name: "index_items_on_reference_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "packed_items", force: :cascade do |t|
    t.bigint "bag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id"
    t.index ["bag_id"], name: "index_packed_items_on_bag_id"
    t.index ["item_id"], name: "index_packed_items_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "item_references", "item_categories", column: "category_id"
  add_foreign_key "items", "item_references", column: "reference_id"
  add_foreign_key "items", "users"
  add_foreign_key "packed_items", "bags"
  add_foreign_key "packed_items", "items"
end
