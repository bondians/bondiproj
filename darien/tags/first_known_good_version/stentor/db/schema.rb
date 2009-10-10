# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091008005025) do

  create_table "accounts", :force => true do |t|
    t.string   "account_number"
    t.integer  "department_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bc_schools", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "default_phone"
    t.string   "default_fax"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_card_batches", :force => true do |t|
    t.integer  "quantity"
    t.boolean  "printed"
    t.string   "batch_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_card_orders", :force => true do |t|
    t.integer  "quantity"
    t.integer  "business_card_batch_id"
    t.boolean  "reprint"
    t.integer  "business_card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
    t.integer  "repeat_count"
  end

  create_table "business_cards", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "title_line_2"
    t.string   "school"
    t.string   "school_line_2"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.boolean  "altEd"
    t.boolean  "distinguished_school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extra"
    t.boolean  "ordered"
  end

  create_table "cardjobs", :force => true do |t|
    t.integer  "job_id"
    t.integer  "business_card_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "copyjobs", :force => true do |t|
    t.integer  "job_id"
    t.integer  "copy_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "due_date"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_admin"
    t.boolean  "admin"
    t.boolean  "user"
  end

end
