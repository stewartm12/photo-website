# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_19_035124) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "add_ons", force: :cascade do |t|
    t.bigint "gallery_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2
    t.boolean "limited", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id"], name: "index_add_ons_on_gallery_id"
  end

  create_table "appointment_add_ons", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "add_on_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_appointment_add_ons_on_add_on_id"
    t.index ["appointment_id"], name: "index_appointment_add_ons_on_appointment_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "package_id", null: false
    t.datetime "preferred_date_time"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["package_id"], name: "index_appointments_on_package_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "gallery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id", "name"], name: "index_collections_on_gallery_id_and_name", unique: true
    t.index ["gallery_id"], name: "index_collections_on_gallery_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "galleries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "active", default: false
    t.index ["name"], name: "index_galleries_on_name", unique: true
    t.index ["slug"], name: "index_galleries_on_slug", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.string "address", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_locations_on_appointment_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "edited_images", default: 0
    t.boolean "outfit_change", default: false
    t.integer "duration"
    t.boolean "popular", default: false
    t.string "features", default: [], array: true
    t.bigint "gallery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id"], name: "index_packages_on_gallery_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "file_key", null: false
    t.string "alt_text"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "section_key"
    t.integer "position"
    t.index ["file_key"], name: "index_photos_on_file_key", unique: true
    t.index ["imageable_type", "imageable_id"], name: "index_photos_on_imageable"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "showcases", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_showcases_on_name", unique: true
  end

  create_table "store_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_memberships_on_store_id"
    t.index ["user_id", "store_id"], name: "index_store_memberships_on_user_id_and_store_id", unique: true
    t.index ["user_id"], name: "index_store_memberships_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "domain", null: false
    t.string "slug", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_stores_on_domain", unique: true
    t.index ["owner_id"], name: "index_stores_on_owner_id"
    t.index ["slug"], name: "index_stores_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "store_memberships", "stores"
  add_foreign_key "store_memberships", "users"
  add_foreign_key "stores", "users", column: "owner_id"
end
