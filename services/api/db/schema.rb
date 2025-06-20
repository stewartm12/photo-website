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

ActiveRecord::Schema[8.0].define(version: 2025_06_20_221947) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "add_ons", force: :cascade do |t|
    t.bigint "gallery_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2
    t.boolean "limited", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id", "name"], name: "index_add_ons_on_gallery_id_and_name", unique: true
    t.index ["gallery_id"], name: "index_add_ons_on_gallery_id"
  end

  create_table "appointment_add_ons", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.boolean "limited", null: false
    t.index ["appointment_id"], name: "index_appointment_add_ons_on_appointment_id"
  end

  create_table "appointment_events", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "user_id"
    t.string "event_type", null: false
    t.text "message", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_events_on_appointment_id"
    t.index ["user_id"], name: "index_appointment_events_on_user_id"
  end

  create_table "appointment_packages", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "edited_images", default: 0
    t.boolean "outfit_change", default: false
    t.integer "duration", default: 0
    t.string "features", default: [], array: true
    t.string "gallery_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_packages_on_appointment_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.datetime "preferred_date_time"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id", null: false
    t.integer "status", default: 0, null: false
    t.decimal "deposit", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["status"], name: "index_appointments_on_status"
    t.index ["store_id"], name: "index_appointments_on_store_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "gallery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "shoot_date"
    t.integer "photos_count", default: 0, null: false
    t.boolean "active", default: false, null: false
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
    t.bigint "store_id", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["first_name", "last_name", "email"], name: "index_customers_on_first_name_and_last_name_and_email", opclass: :gin_trgm_ops, using: :gin
    t.index ["store_id"], name: "index_customers_on_store_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "active", default: false
    t.bigint "store_id", null: false
    t.integer "collections_count", default: 0, null: false
    t.integer "packages_count", default: 0, null: false
    t.integer "add_ons_count", default: 0, null: false
    t.index ["store_id", "name"], name: "index_galleries_on_store_id_and_name", unique: true
    t.index ["store_id", "slug"], name: "index_galleries_on_store_id_and_slug", unique: true
    t.index ["store_id"], name: "index_galleries_on_store_id"
  end

  create_table "invoice_line_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "name", null: false
    t.string "item_type", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "unit_price", null: false
    t.decimal "total_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_line_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.string "invoice_number", null: false
    t.decimal "subtotal", null: false
    t.decimal "tax"
    t.decimal "total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "unpaid", null: false
    t.decimal "deposit", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "paid_at"
    t.decimal "paid_amount", precision: 10, scale: 2, default: "0.0"
    t.index ["appointment_id"], name: "index_invoices_on_appointment_id"
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
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
    t.index ["gallery_id", "name"], name: "index_packages_on_gallery_id_and_name", unique: true
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
    t.index ["imageable_type", "imageable_id", "file_key"], name: "index_photos_on_imageable_type_and_imageable_id_and_file_key", unique: true
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
    t.bigint "store_id", null: false
    t.integer "photos_count", default: 0, null: false
    t.index ["store_id", "name"], name: "index_showcases_on_store_id_and_name", unique: true
    t.index ["store_id"], name: "index_showcases_on_store_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
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
    t.integer "galleries_count", default: 0, null: false
    t.string "email"
    t.integer "appointments_count", default: 0, null: false
    t.integer "customers_count", default: 0, null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appointment_events", "appointments"
  add_foreign_key "appointment_events", "users"
  add_foreign_key "appointments", "stores"
  add_foreign_key "customers", "stores"
  add_foreign_key "galleries", "stores"
  add_foreign_key "invoice_line_items", "invoices"
  add_foreign_key "invoices", "appointments"
  add_foreign_key "sessions", "users"
  add_foreign_key "store_memberships", "stores"
  add_foreign_key "store_memberships", "users"
  add_foreign_key "stores", "users", column: "owner_id"
end
