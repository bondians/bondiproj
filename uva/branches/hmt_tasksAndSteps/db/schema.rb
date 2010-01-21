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

ActiveRecord::Schema.define(:version => 20100117070659) do

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
    t.string   "short_name", :limit => 6
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
    t.integer  "task_id"
    t.boolean  "completed"
    t.datetime "due"
    t.integer  "task_type_id"
    t.decimal  "total_cost",           :precision => 9, :scale => 2
    t.text     "tasks_list_formatted"
    t.date     "completed_date"
  end

  create_table "task_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "required_task"
    t.boolean  "quick_copy_default_task"
    t.boolean  "full_job_default_task"
    t.integer  "default_task_order"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.boolean  "completed"
    t.date     "completed_date"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "step_needed"
    t.integer  "order"
    t.integer  "task_type_id"
    t.decimal  "item_cost",                               :precision => 12, :scale => 5
    t.string   "type_name",                 :limit => 15
    t.string   "type"
    t.integer  "billable_minutes"
    t.string   "design_description"
    t.boolean  "design_charge_by_minutes"
    t.string   "design_path_on_server"
    t.string   "copy_description"
    t.string   "copy_machine"
    t.integer  "copy_originals_quantity"
    t.integer  "copy_copies_quantity"
    t.boolean  "copy_tab_dividers"
    t.integer  "copy_tab_dividers_count"
    t.integer  "paper_color_id"
    t.integer  "paper_size_id"
    t.integer  "card_stock_color_id"
    t.boolean  "copier_staple"
    t.integer  "copier_staple_type_id"
    t.boolean  "copier_bind"
    t.integer  "copier_bind_type_id"
    t.boolean  "copier_fold"
    t.integer  "copier_fold_type_id"
    t.boolean  "copier_collate"
    t.string   "press_description"
    t.string   "press_ink_colors"
    t.string   "bindery_description"
    t.integer  "bindery_billable_minutes"
    t.boolean  "bindery_charge_by_minutes"
    t.boolean  "bindery_hole_punch"
    t.boolean  "bindery_paper_band"
    t.boolean  "bindery_laminate"
    t.boolean  "bindery_pad"
    t.integer  "bindery_sheets_per_pad"
    t.boolean  "bindery_cut"
    t.boolean  "bindery_score"
    t.boolean  "bindery_fold"
    t.boolean  "bindery_staple"
    t.boolean  "bindery_bind"
    t.string   "bindery_bind_style"
    t.integer  "ship_method_id"
    t.boolean  "ship_call_when_ready"
    t.string   "ship_phone_number"
    t.string   "price_description"
    t.integer  "price_flat_rate"
    t.boolean  "price_use_flat_rate"
    t.string   "accounting_description"
    t.integer  "accounting_batch"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
