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

ActiveRecord::Schema.define(:version => 20090302054450) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.integer  "artist_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", :force => true do |t|
    t.string   "name"
    t.integer  "track"
    t.integer  "year"
    t.integer  "album_id"
    t.integer  "artist_id"
    t.integer  "genre_id"
    t.text     "comments"
    t.integer  "size"
    t.integer  "pre_id"
    t.integer  "post_id"
    t.float    "fade_duration",  :default => -1.0
    t.float    "volume",         :default => 0.7
    t.boolean  "fade_in",        :default => true
    t.integer  "user_id"
    t.integer  "archive_number"
    t.text     "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
