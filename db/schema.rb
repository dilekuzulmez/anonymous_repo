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

ActiveRecord::Schema.define(version: 20180927043351) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "uid"
    t.string "provider"
    t.string "first_name"
    t.string "last_name"
    t.string "profile_image_url"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id"
    t.string "employee_token"
    t.datetime "token_expire"
    t.index ["created_by_id"], name: "index_admins_on_created_by_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "gender", limit: 32
    t.date "birthday"
    t.string "phone_number", limit: 32
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "address"
    t.index ["email", "phone_number"], name: "index_customers_on_email_and_phone_number", unique: true
  end

  create_table "customers_promotions", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "promotion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_used", default: 0
    t.index ["customer_id"], name: "index_customers_promotions_on_customer_id"
    t.index ["promotion_id"], name: "index_customers_promotions_on_promotion_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "stadium_id"
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.string "round"
    t.datetime "start_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "season_id"
    t.string "name"
    t.integer "home_team_score", default: 0
    t.integer "away_team_score", default: 0
    t.boolean "active", default: true
    t.index ["away_team_id"], name: "index_matches_on_away_team_id"
    t.index ["home_team_id"], name: "index_matches_on_home_team_id"
    t.index ["season_id"], name: "index_matches_on_season_id"
    t.index ["stadium_id"], name: "index_matches_on_stadium_id"
    t.index ["start_time"], name: "index_matches_on_start_time"
  end

  create_table "matchs_promotions", force: :cascade do |t|
    t.bigint "match_id"
    t.bigint "promotion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_matchs_promotions_on_match_id"
    t.index ["promotion_id"], name: "index_matchs_promotions_on_promotion_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "ticket_type_id"
    t.integer "quantity", null: false
    t.decimal "unit_price", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "match_id"
    t.datetime "expired_at"
    t.string "hash_key"
    t.boolean "is_qr_used", default: false
    t.string "qr_code_file_name"
    t.index ["match_id"], name: "index_order_details_on_match_id"
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["ticket_type_id"], name: "index_order_details_on_ticket_type_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "shipping_address"
    t.bigint "created_by_id"
    t.string "created_by_type"
    t.boolean "paid", default: false
    t.string "promotion_code", limit: 32
    t.decimal "discount_amount", default: "0.0", null: false
    t.string "discount_type", limit: 128
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "purchased_date"
    t.string "sale_channel", default: "COD"
    t.integer "status"
    t.index ["created_by_id", "created_by_type"], name: "index_orders_on_created_by_id_and_created_by_type"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "code", limit: 32, null: false
    t.string "slug"
    t.string "discount_type", limit: 32, null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "active", default: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.integer "limit_number_used"
    t.date "start_date"
    t.date "end_date"
    t.index ["code"], name: "index_promotions_on_code", unique: true
    t.index ["slug"], name: "index_promotions_on_slug", unique: true
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.daterange "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: false
  end

  create_table "seasons_teams", id: false, force: :cascade do |t|
    t.bigint "season_id"
    t.bigint "team_id"
    t.index ["season_id"], name: "index_seasons_teams_on_season_id"
    t.index ["team_id"], name: "index_seasons_teams_on_team_id"
  end

  create_table "stadiums", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "contact"
    t.string "slug"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stadiums_on_name"
    t.index ["slug"], name: "index_stadiums_on_slug", unique: true
    t.index ["team_id"], name: "index_stadiums_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["name"], name: "index_teams_on_name"
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "ticket_types", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "zone_id"
    t.integer "quantity", null: false
    t.string "code", null: false
    t.string "slug"
    t.decimal "price", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "class_type", default: 0, null: false
    t.index ["match_id", "code"], name: "index_ticket_types_on_match_id_and_code", unique: true
    t.index ["match_id"], name: "index_ticket_types_on_match_id"
    t.index ["slug"], name: "index_ticket_types_on_slug", unique: true
    t.index ["zone_id"], name: "index_ticket_types_on_zone_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "customer_id"
    t.string "request_ip", null: false
    t.string "key", null: false
    t.integer "status", null: false
    t.decimal "amount", default: "0.0", null: false
    t.hstore "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "opamount", default: "0.0"
    t.decimal "discount_amount_123", default: "0.0"
    t.index ["customer_id"], name: "index_transaction_histories_on_customer_id"
    t.index ["order_id"], name: "index_transaction_histories_on_order_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.integer "capacity", default: 0, null: false
    t.decimal "price", default: "0.0", null: false
    t.string "slug"
    t.bigint "stadium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone_type", default: 0, null: false
    t.index ["code", "stadium_id"], name: "index_zones_on_code_and_stadium_id", unique: true
    t.index ["slug"], name: "index_zones_on_slug", unique: true
    t.index ["stadium_id"], name: "index_zones_on_stadium_id"
  end

  add_foreign_key "admins", "admins", column: "created_by_id"
  add_foreign_key "customers_promotions", "customers"
  add_foreign_key "customers_promotions", "promotions"
  add_foreign_key "matches", "seasons"
  add_foreign_key "matches", "stadiums"
  add_foreign_key "matches", "teams", column: "away_team_id", on_delete: :nullify
  add_foreign_key "matches", "teams", column: "home_team_id", on_delete: :nullify
  add_foreign_key "matchs_promotions", "matches"
  add_foreign_key "matchs_promotions", "promotions"
  add_foreign_key "order_details", "matches"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "ticket_types"
  add_foreign_key "ticket_types", "matches"
  add_foreign_key "ticket_types", "zones"
  add_foreign_key "transaction_histories", "customers"
  add_foreign_key "transaction_histories", "orders"
  add_foreign_key "zones", "stadiums"
end
