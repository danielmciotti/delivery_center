# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_08_232252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "buyers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_code"
    t.string "nickname"
    t.string "first_name"
    t.string "last_name"
    t.jsonb "phone"
    t.jsonb "billing_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "externalCode"
    t.string "title"
    t.uuid "order_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_item_id"], name: "index_items_on_order_item_id"
  end

  create_table "order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "quantity"
    t.float "unit_price"
    t.float "full_unit_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_code"
    t.string "status"
    t.string "payment_type"
    t.integer "installments"
    t.float "transaction_amount"
    t.float "taxes_amount"
    t.float "shipping_cost"
    t.float "total_paid_amount"
    t.float "installment_amount"
    t.datetime "date_approved"
    t.datetime "date_created"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "receiver_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address_line"
    t.string "street_name"
    t.string "street_number"
    t.string "comment"
    t.string "zip_code"
    t.float "latitude"
    t.float "longitude"
    t.string "receiver_phone"
    t.jsonb "city"
    t.jsonb "state"
    t.jsonb "country"
    t.jsonb "neighborhood"
    t.uuid "shipment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_receiver_addresses_on_shipment_id"
  end

  create_table "shipments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "external_code"
    t.string "shipment_type"
    t.datetime "date_created"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "items", "order_items"
  add_foreign_key "receiver_addresses", "shipments"
end
