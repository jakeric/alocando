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

ActiveRecord::Schema.define(version: 2018_08_13_155649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airlines", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "airports", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_airports_on_city_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "timezone"
    t.string "description"
    t.string "sight_one"
    t.string "sight_two"
    t.string "sight_three"
    t.string "restaurant_one"
    t.string "restaurant_two"
    t.string "restaurant_three"
    t.string "bar_one"
    t.string "bar_two"
    t.string "bar_three"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flight_bundle_flights", force: :cascade do |t|
    t.bigint "flight_id"
    t.bigint "flight_bundle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_bundle_id"], name: "index_flight_bundle_flights_on_flight_bundle_id"
    t.index ["flight_id"], name: "index_flight_bundle_flights_on_flight_id"
  end

  create_table "flight_bundles", force: :cascade do |t|
    t.float "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flights", force: :cascade do |t|
    t.datetime "departure_datetime"
    t.datetime "arrival_datetime"
    t.float "price"
    t.float "flight_duration"
    t.bigint "from_airport_id"
    t.bigint "to_airport_id"
    t.bigint "airline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_id"], name: "index_flights_on_airline_id"
    t.index ["from_airport_id"], name: "index_flights_on_from_airport_id"
    t.index ["to_airport_id"], name: "index_flights_on_to_airport_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "photo"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_photos_on_city_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "airports", "cities"
  add_foreign_key "flight_bundle_flights", "flight_bundles"
  add_foreign_key "flight_bundle_flights", "flights"
  add_foreign_key "flights", "airlines"
  add_foreign_key "photos", "cities"
end
