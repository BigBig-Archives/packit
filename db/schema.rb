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

ActiveRecord::Schema.define(version: 2018_09_09_204116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bag_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bag_refs", force: :cascade do |t|
    t.string "name"
    t.integer "size"
    t.integer "capacity"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.string "picture"
    t.index ["category_id"], name: "index_bag_refs_on_category_id"
  end

  create_table "bags", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reference_id"
    t.integer "custom_size"
    t.integer "custom_capacity"
    t.integer "custom_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["reference_id"], name: "index_bags_on_reference_id"
    t.index ["user_id"], name: "index_bags_on_user_id"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
  end

  create_table "item_refs", force: :cascade do |t|
    t.string "name"
    t.integer "size"
    t.integer "weight"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_item_refs_on_category_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reference_id"
    t.string "commentary"
    t.integer "custom_size"
    t.integer "custom_weight"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference_id"], name: "index_items_on_reference_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "journey_bags", force: :cascade do |t|
    t.bigint "journey_id"
    t.bigint "packed_bag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journey_id"], name: "index_journey_bags_on_journey_id"
    t.index ["packed_bag_id"], name: "index_journey_bags_on_packed_bag_id"
  end

  create_table "journeys", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "category"
    t.string "country"
    t.string "city"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_journeys_on_user_id"
  end

  create_table "packed_bags", force: :cascade do |t|
    t.bigint "bag_id"
    t.integer "custom_load"
    t.integer "custom_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["bag_id"], name: "index_packed_bags_on_bag_id"
  end

  create_table "packed_items", force: :cascade do |t|
    t.bigint "packed_bag_id"
    t.bigint "item_id"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_packed_items_on_item_id"
    t.index ["packed_bag_id"], name: "index_packed_items_on_packed_bag_id"
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
    t.string "first_name"
    t.string "last_name"
    t.string "photo"
    t.integer "size"
    t.integer "traveller_category"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bag_refs", "bag_categories", column: "category_id"
  add_foreign_key "bags", "bag_refs", column: "reference_id"
  add_foreign_key "bags", "users"
  add_foreign_key "item_refs", "item_categories", column: "category_id"
  add_foreign_key "items", "item_refs", column: "reference_id"
  add_foreign_key "items", "users"
  add_foreign_key "journey_bags", "journeys"
  add_foreign_key "journey_bags", "packed_bags"
  add_foreign_key "journeys", "users"
  add_foreign_key "packed_bags", "bags"
  add_foreign_key "packed_items", "items"
  add_foreign_key "packed_items", "packed_bags"
end
