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

ActiveRecord::Schema.define(:version => 20090920065321) do

  create_table "oversupplies", :force => true do |t|
    t.string   "name"
    t.string   "building"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "user_date"
    t.string   "contact"
  end

  create_table "surplus", :force => true do |t|
    t.string   "from"
    t.string   "building_number"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surplus_items", :force => true do |t|
    t.string   "description"
    t.string   "make_model"
    t.string   "inventory_id_tag_number"
    t.integer  "quantity"
    t.string   "condition_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oversupply_id"
  end

end
