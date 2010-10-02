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

ActiveRecord::Schema.define(:version => 20100709173414) do

  create_table "abuses", :force => true do |t|
    t.text     "abuse"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albumartists", :force => true do |t|
    t.integer  "album_id"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finders", :force => true do |t|
    t.datetime "started"
    t.datetime "completed"
    t.integer  "added"
    t.integer  "removed"
    t.boolean  "success"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plentries", :force => true do |t|
    t.integer  "song_id"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idx"
    t.text     "file"
  end

  create_table "songs", :force => true do |t|
    t.string   "title"
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
    t.integer  "songtype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songtypes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "identifier"
    t.string   "mime_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end