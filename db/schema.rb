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

ActiveRecord::Schema[7.0].define(version: 2025_05_04_175436) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addon_options", force: :cascade do |t|
    t.bigint "addon_id"
    t.string "name"
    t.text "description"
    t.decimal "price_pennies_each"
    t.boolean "quantifiable", default: false
    t.string "quantifiable_text"
    t.boolean "booleanable", default: false
    t.boolean "textable", default: false
    t.integer "min", default: 1
    t.integer "max", default: 10
    t.integer "sort_order", default: 0
    t.index ["addon_id"], name: "index_addon_options_on_addon_id"
  end

  create_table "addons", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apartment_addons", force: :cascade do |t|
    t.bigint "apartment_id"
    t.bigint "addon_id"
    t.boolean "available", default: true
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_apartment_addons_on_addon_id"
    t.index ["apartment_id"], name: "index_apartment_addons_on_apartment_id"
  end

  create_table "apartment_transactions", force: :cascade do |t|
    t.bigint "transaction_id"
    t.bigint "apartment_id"
    t.decimal "amount"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_apartment_transactions_on_apartment_id"
    t.index ["transaction_id"], name: "index_apartment_transactions_on_transaction_id"
  end

  create_table "apartments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "colour", default: "primary"
    t.integer "sort_order", default: 0
    t.boolean "has_parking", default: false
    t.integer "lockbox_pin"
    t.integer "beds"
    t.integer "sofabeds"
    t.boolean "is_enabled", default: false
    t.string "address"
    t.string "wifi_name"
    t.string "wifi_password"
  end

  create_table "booking_addon_options", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "addon_id"
    t.bigint "addon_option_id"
    t.text "option_value"
    t.decimal "current_price_pennies"
    t.boolean "paid", default: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_booking_addon_options_on_addon_id"
    t.index ["addon_option_id"], name: "index_booking_addon_options_on_addon_option_id"
    t.index ["booking_id"], name: "index_booking_addon_options_on_booking_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.string "reference_id"
    t.string "booking_type"
    t.date "arrival"
    t.date "departure"
    t.datetime "data_created_at"
    t.datetime "data_modified_at"
    t.bigint "apartment_id"
    t.bigint "channel_id"
    t.string "guest_name"
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "phone"
    t.integer "adults"
    t.integer "children"
    t.time "check_in"
    t.time "check_out"
    t.text "notice"
    t.text "assistant_notice"
    t.decimal "price", precision: 8, scale: 2
    t.text "price_details"
    t.decimal "city_tax", precision: 8, scale: 2
    t.boolean "price_paid", default: false
    t.decimal "commission_included", precision: 8, scale: 2
    t.decimal "payment_charge", precision: 8, scale: 2
    t.decimal "prepayment", precision: 8, scale: 2
    t.boolean "prepayment_paid", default: false
    t.decimal "deposit", precision: 8, scale: 2
    t.boolean "deposit_paid", default: false
    t.string "language"
    t.string "guest_app_url"
    t.boolean "is_blocked_booking", default: false
    t.integer "guest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guest_input_firstname"
    t.string "guest_input_lastname"
    t.integer "guest_input_guestcount"
    t.string "guest_input_email"
    t.datetime "guest_input_eta"
    t.boolean "guest_input_sofabed", default: false
    t.boolean "guest_input_parking", default: false
    t.time "check_in_time", default: "2000-01-01 15:00:00"
    t.time "check_out_time", default: "2000-01-01 10:00:00"
    t.boolean "guest_has_viewed_extras", default: false
    t.string "extras_payment_method", default: "deposit"
    t.string "lockbox_code"
    t.string "keynest_code"
    t.index ["apartment_id"], name: "index_bookings_on_apartment_id"
    t.index ["channel_id"], name: "index_bookings_on_channel_id"
    t.index ["guest_id"], name: "index_bookings_on_guest_id"
    t.index ["reference_id"], name: "index_bookings_on_reference_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "deposits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_payment_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "direct_payments", force: :cascade do |t|
    t.bigint "apartment_id"
    t.bigint "booking_id"
    t.bigint "direct_payment_type_id"
    t.string "payment_id"
    t.string "payment_intent"
    t.string "customer_name"
    t.string "email"
    t.integer "total_pennies"
    t.string "status"
    t.text "description"
    t.boolean "processed", default: false
    t.datetime "data_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_direct_payments_on_apartment_id"
    t.index ["booking_id"], name: "index_direct_payments_on_booking_id"
    t.index ["direct_payment_type_id"], name: "index_direct_payments_on_direct_payment_type_id"
  end

  create_table "expense_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keys", force: :cascade do |t|
    t.string "name"
    t.bigint "apartment_id"
    t.integer "store_id"
    t.string "key_id"
    t.string "status_type"
    t.datetime "last_movement"
    t.string "current_status"
    t.string "drop_off_code"
    t.string "collection_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_keys_on_apartment_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "role_id"
    t.string "controller"
    t.string "action"
    t.string "misc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "booking_id"
    t.string "request_type"
    t.string "request_action"
    t.string "link"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", default: 0
    t.boolean "expired", default: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "assigner_user_id"
    t.integer "assignee_user_id"
    t.integer "apartment_id"
    t.string "assignee_name"
    t.integer "task_type_id"
    t.datetime "task_assigned"
    t.datetime "task_due"
    t.integer "booking_id"
    t.decimal "rate_per_task"
    t.string "status"
    t.boolean "qa_approved_timestamp"
    t.boolean "qa_approver_user_id"
    t.boolean "paid"
    t.boolean "payment_acknowledged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_id"
    t.string "feedItemUid"
    t.decimal "amount_pennies"
    t.string "direction"
    t.string "status"
    t.string "source"
    t.string "account_name"
    t.datetime "transaction_timestamp"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.boolean "processed", default: false
    t.integer "expense_type_id"
    t.string "payment_method", default: "business_bank"
    t.index ["feedItemUid"], name: "index_transactions_on_feedItemUid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "apartment_transactions", "apartments"
  add_foreign_key "apartment_transactions", "transactions"
  add_foreign_key "bookings", "apartments"
  add_foreign_key "bookings", "channels"
end
