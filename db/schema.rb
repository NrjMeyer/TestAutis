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

ActiveRecord::Schema.define(version: 20170524144243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advantages", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "advantages_offers", id: false, force: :cascade do |t|
    t.integer "advantage_id"
    t.integer "offer_id"
    t.index ["advantage_id"], name: "index_advantages_offers_on_advantage_id", using: :btree
    t.index ["offer_id"], name: "index_advantages_offers_on_offer_id", using: :btree
  end

  create_table "cache_users", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "email"
    t.string   "name"
    t.string   "surname"
    t.string   "phone_number"
    t.text     "address"
    t.text     "address_extend"
    t.integer  "post_code"
    t.string   "city"
    t.boolean  "tax_receipt"
    t.boolean  "newsletter"
    t.string   "payment_id"
    t.string   "password"
    t.string   "offer_id"
    t.integer  "payment_amount"
    t.boolean  "monthly"
  end

  create_table "card_payments", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "user_id"
    t.string   "payment_reference"
    t.integer  "amount"
  end

  create_table "cheque_payments", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "amount"
    t.boolean  "validated"
    t.integer  "user_id"
    t.integer  "cache_user_id"
  end

  create_table "dons", force: :cascade do |t|
    t.integer  "amount"
    t.string   "user_id"
    t.string   "cache_user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "slimpay_payment_id"
    t.string   "paypal_payment_id"
    t.string   "card_payment_id"
    t.string   "cheque_payment_id"
    t.boolean  "validated",          default: false
    t.boolean  "recurring"
    t.string   "donor_name"
    t.string   "donor_mail"
    t.string   "donor_surname"
    t.string   "donor_adress"
    t.string   "donor_phone"
    t.boolean  "fiscal_mail"
  end

  create_table "money_divisions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "part"
    t.string   "use"
  end

  create_table "offer_dons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "amount"
    t.string   "story"
  end

  create_table "offers", force: :cascade do |t|
    t.integer  "amount"
    t.boolean  "mensualisable"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "role"
  end

  create_table "paypal_payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_id"
    t.string   "payment"
    t.string   "payer"
    t.string   "token"
    t.integer  "amount"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "side_users", force: :cascade do |t|
    t.string   "user_id"
    t.string   "cache_user_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "slimpay_payments", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "user_id"
    t.string   "cache_user_id"
    t.string   "payment_reference"
    t.integer  "amount"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "surname"
    t.string   "phone_number"
    t.text     "address"
    t.text     "address_extend"
    t.integer  "post_code"
    t.string   "city"
    t.boolean  "tax_receipt"
    t.boolean  "newsletter"
    t.datetime "last_payment"
    t.boolean  "monthly_payment"
    t.string   "payment_option"
    t.integer  "offer_id"
    t.boolean  "admin",                  default: false
    t.string   "admintype"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
