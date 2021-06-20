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

ActiveRecord::Schema.define(version: 2021_06_20_075822) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bank_codes", force: :cascade do |t|
    t.string "code"
    t.string "bank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "block_companies", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "email_1"
    t.string "email_2"
    t.boolean "vote_1", default: true, null: false
    t.boolean "vote_2", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_block_companies_on_company_id"
  end

  create_table "boleto_register_options", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "token"
    t.string "agency_number"
    t.string "account_number"
    t.integer "payment_option_id", null: false
    t.string "name"
    t.decimal "fee"
    t.decimal "max_money_fee"
    t.integer "bank_code_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["bank_code_id"], name: "index_boleto_register_options_on_bank_code_id"
    t.index ["company_id"], name: "index_boleto_register_options_on_company_id"
    t.index ["payment_option_id"], name: "index_boleto_register_options_on_payment_option_id"
  end

  create_table "charges", force: :cascade do |t|
    t.string "token"
    t.string "client_name"
    t.string "client_cpf"
    t.string "client_token"
    t.string "product_token"
    t.string "company_token"
    t.string "payment_method"
    t.string "client_address"
    t.string "card_number"
    t.string "card_name"
    t.string "cvv_code"
    t.decimal "price"
    t.decimal "discount"
    t.string "product_name"
    t.decimal "charge_price"
    t.date "due_deadline"
    t.date "payment_date"
    t.date "attempt_date"
    t.integer "company_id", null: false
    t.integer "product_id", null: false
    t.integer "final_client_id", null: false
    t.integer "boleto_register_option_id"
    t.integer "credit_card_register_option_id"
    t.integer "pix_register_option_id"
    t.integer "status_charge_id", null: false
    t.integer "payment_option_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status_returned"
    t.string "status_returned_code"
    t.index ["boleto_register_option_id"], name: "index_charges_on_boleto_register_option_id"
    t.index ["company_id"], name: "index_charges_on_company_id"
    t.index ["credit_card_register_option_id"], name: "index_charges_on_credit_card_register_option_id"
    t.index ["final_client_id"], name: "index_charges_on_final_client_id"
    t.index ["payment_option_id"], name: "index_charges_on_payment_option_id"
    t.index ["pix_register_option_id"], name: "index_charges_on_pix_register_option_id"
    t.index ["product_id"], name: "index_charges_on_product_id"
    t.index ["status_charge_id"], name: "index_charges_on_status_charge_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "corporate_name"
    t.string "cnpj"
    t.string "state"
    t.string "city"
    t.string "district"
    t.string "street"
    t.string "number"
    t.string "address_complement"
    t.string "billing_email"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
  end

  create_table "company_clients", force: :cascade do |t|
    t.integer "final_client_id", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_clients_on_company_id"
    t.index ["final_client_id"], name: "index_company_clients_on_final_client_id"
  end

  create_table "credit_card_register_options", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "credit_card_operator_token"
    t.integer "payment_option_id", null: false
    t.string "name"
    t.decimal "fee"
    t.decimal "max_money_fee"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["company_id"], name: "index_credit_card_register_options_on_company_id"
    t.index ["payment_option_id"], name: "index_credit_card_register_options_on_payment_option_id"
  end

  create_table "domain_records", force: :cascade do |t|
    t.string "email"
    t.string "email_client_admin"
    t.string "domain"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.index ["company_id"], name: "index_domain_records_on_company_id"
  end

  create_table "final_clients", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "historic_companies", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "token"
    t.string "corporate_name"
    t.string "cnpj"
    t.string "state"
    t.string "city"
    t.string "district"
    t.string "street"
    t.string "number"
    t.string "address_complement"
    t.string "billing_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_historic_companies_on_company_id"
  end

  create_table "historic_products", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "company_id", null: false
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "boleto_discount"
    t.string "credit_card_discount"
    t.string "pix_discount"
    t.index ["company_id"], name: "index_historic_products_on_company_id"
    t.index ["product_id"], name: "index_historic_products_on_product_id"
  end

  create_table "payment_companies", force: :cascade do |t|
    t.integer "payment_option_id", null: false
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_payment_companies_on_company_id"
    t.index ["payment_option_id"], name: "index_payment_companies_on_payment_option_id"
  end

  create_table "payment_options", force: :cascade do |t|
    t.string "name"
    t.decimal "fee"
    t.decimal "max_money_fee"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "payment_type", default: 0, null: false
  end

  create_table "pix_register_options", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "pix_key"
    t.integer "bank_code_id", null: false
    t.integer "payment_option_id", null: false
    t.string "name"
    t.decimal "fee"
    t.decimal "max_money_fee"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["bank_code_id"], name: "index_pix_register_options_on_bank_code_id"
    t.index ["company_id"], name: "index_pix_register_options_on_company_id"
    t.index ["payment_option_id"], name: "index_pix_register_options_on_payment_option_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.decimal "boleto_discount", default: "0.0"
    t.decimal "pix_discount", default: "0.0"
    t.decimal "credit_card_discount", default: "0.0"
    t.string "token"
    t.integer "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.date "due_deadline"
    t.date "payment_date"
    t.string "authorization_token"
    t.integer "charge_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["charge_id"], name: "index_receipts_on_charge_id"
  end

  create_table "status_charges", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.integer "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "block_companies", "companies"
  add_foreign_key "boleto_register_options", "bank_codes"
  add_foreign_key "boleto_register_options", "companies"
  add_foreign_key "boleto_register_options", "payment_options"
  add_foreign_key "charges", "boleto_register_options"
  add_foreign_key "charges", "companies"
  add_foreign_key "charges", "credit_card_register_options"
  add_foreign_key "charges", "final_clients"
  add_foreign_key "charges", "payment_options"
  add_foreign_key "charges", "pix_register_options"
  add_foreign_key "charges", "products"
  add_foreign_key "charges", "status_charges"
  add_foreign_key "company_clients", "companies"
  add_foreign_key "company_clients", "final_clients"
  add_foreign_key "credit_card_register_options", "companies"
  add_foreign_key "credit_card_register_options", "payment_options"
  add_foreign_key "domain_records", "companies"
  add_foreign_key "historic_companies", "companies"
  add_foreign_key "historic_products", "companies"
  add_foreign_key "historic_products", "products"
  add_foreign_key "payment_companies", "companies"
  add_foreign_key "payment_companies", "payment_options"
  add_foreign_key "pix_register_options", "bank_codes"
  add_foreign_key "pix_register_options", "companies"
  add_foreign_key "pix_register_options", "payment_options"
  add_foreign_key "products", "companies"
  add_foreign_key "receipts", "charges"
  add_foreign_key "users", "companies"
end
