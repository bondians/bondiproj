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

ActiveRecord::Schema.define(:version => 20091228224008) do

  create_table "accounts", :force => true do |t|
    t.string   "number",        :limit => 15
    t.integer  "department_id"
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
    t.text     "description"
    t.date     "due_date"
    t.time     "due_time"
    t.date     "submit_date"
    t.string   "ordered_by"
    t.string   "input_person"
    t.boolean  "auth_sig"
    t.integer  "department_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "received_date"
    t.string   "ticket"
    t.integer  "workflow_id"
    t.boolean  "completed"
    t.datetime "due"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.boolean  "completed"
    t.date     "completed_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflows", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.boolean  "completed"
    t.date     "completed_date"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "step_needed"
    t.integer  "order"
  end

end
