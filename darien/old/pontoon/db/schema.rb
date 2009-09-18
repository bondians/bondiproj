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

ActiveRecord::Schema.define(:version => 20090721201646) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "phone_area_code"
    t.string   "fax_number"
    t.string   "fax_area_code"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphic_arts_people", :force => true do |t|
    t.string   "name"
    t.string   "highlight_color_one"
    t.string   "highlight_color_two"
    t.string   "highlight_color_three"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inquiries", :force => true do |t|
    t.integer  "person_id"
    t.integer  "department_id"
    t.text     "message_text"
    t.integer  "person_phone"
    t.integer  "graphic_arts_person"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "alternate_last_name"
    t.integer  "phone_id"
    t.string   "email_name"
    t.string   "email_domain"
    t.integer  "department_id"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "person_phones", :force => true do |t|
    t.integer  "person"
    t.integer  "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_types", :force => true do |t|
    t.string   "phone_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.string   "phone_number"
    t.string   "phone_area_code"
    t.integer  "phone_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
