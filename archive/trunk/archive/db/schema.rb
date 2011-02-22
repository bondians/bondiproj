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

ActiveRecord::Schema.define(:version => 20101101162409) do

  create_table "abuses", :force => true do |t|
    t.text     "abuse"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apids", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "culls", :force => true do |t|
    t.string   "file"
    t.text     "reason"
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

  create_table "goldberg_content_pages", :force => true do |t|
    t.string   "title"
    t.string   "name",            :null => false
    t.integer  "markup_style_id"
    t.text     "content"
    t.integer  "permission_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_cache"
    t.string   "markup_style"
  end

  add_index "goldberg_content_pages", ["markup_style_id"], :name => "fk_content_page_markup_style_id"
  add_index "goldberg_content_pages", ["permission_id"], :name => "fk_content_page_permission_id"

  create_table "goldberg_controller_actions", :force => true do |t|
    t.integer "site_controller_id", :null => false
    t.string  "name",               :null => false
    t.integer "permission_id"
    t.string  "url_to_use"
  end

  add_index "goldberg_controller_actions", ["permission_id"], :name => "fk_controller_action_permission_id"
  add_index "goldberg_controller_actions", ["site_controller_id"], :name => "fk_controller_action_site_controller_id"

  create_table "goldberg_menu_items", :force => true do |t|
    t.integer "parent_id"
    t.string  "name",                 :null => false
    t.string  "label",                :null => false
    t.integer "seq"
    t.integer "controller_action_id"
    t.integer "content_page_id"
  end

  add_index "goldberg_menu_items", ["content_page_id"], :name => "fk_menu_item_content_page_id"
  add_index "goldberg_menu_items", ["controller_action_id"], :name => "fk_menu_item_controller_action_id"
  add_index "goldberg_menu_items", ["parent_id"], :name => "fk_menu_item_parent_id"

  create_table "goldberg_permissions", :force => true do |t|
    t.string "name", :default => "", :null => false
  end

  create_table "goldberg_roles", :force => true do |t|
    t.string   "name",                            :null => false
    t.integer  "parent_id"
    t.string   "description",     :default => "", :null => false
    t.integer  "default_page_id"
    t.text     "cache"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "start_path"
  end

  add_index "goldberg_roles", ["default_page_id"], :name => "fk_role_default_page_id"
  add_index "goldberg_roles", ["parent_id"], :name => "fk_role_parent_id"

  create_table "goldberg_roles_permissions", :force => true do |t|
    t.integer "role_id",       :null => false
    t.integer "permission_id", :null => false
  end

  add_index "goldberg_roles_permissions", ["permission_id"], :name => "fk_roles_permission_permission_id"
  add_index "goldberg_roles_permissions", ["role_id"], :name => "fk_roles_permission_role_id"

  create_table "goldberg_site_controllers", :force => true do |t|
    t.string  "name",                         :null => false
    t.integer "permission_id",                :null => false
    t.integer "builtin",       :default => 0
  end

  add_index "goldberg_site_controllers", ["permission_id"], :name => "fk_site_controller_permission_id"

  create_table "goldberg_system_settings", :force => true do |t|
    t.string  "site_name",                                           :null => false
    t.string  "site_subtitle"
    t.string  "footer_message",                      :default => ""
    t.integer "public_role_id",                                      :null => false
    t.integer "session_timeout",                     :default => 0,  :null => false
    t.integer "site_default_page_id",                                :null => false
    t.integer "not_found_page_id",                                   :null => false
    t.integer "permission_denied_page_id",                           :null => false
    t.integer "session_expired_page_id",                             :null => false
    t.integer "menu_depth",                          :default => 0,  :null => false
    t.string  "start_path"
    t.string  "site_url_prefix"
    t.boolean "self_reg_enabled"
    t.integer "self_reg_role_id"
    t.boolean "self_reg_confirmation_required"
    t.integer "self_reg_confirmation_error_page_id"
    t.boolean "self_reg_send_confirmation_email"
  end

  add_index "goldberg_system_settings", ["not_found_page_id"], :name => "fk_system_settings_not_found_page_id"
  add_index "goldberg_system_settings", ["permission_denied_page_id"], :name => "fk_system_settings_permission_denied_page_id"
  add_index "goldberg_system_settings", ["public_role_id"], :name => "fk_system_settings_public_role_id"
  add_index "goldberg_system_settings", ["session_expired_page_id"], :name => "fk_system_settings_session_expired_page_id"
  add_index "goldberg_system_settings", ["site_default_page_id"], :name => "fk_system_settings_site_default_page_id"

  create_table "goldberg_users", :force => true do |t|
    t.string   "name",                                         :null => false
    t.string   "password",                       :limit => 40, :null => false
    t.integer  "role_id",                                      :null => false
    t.string   "password_salt"
    t.string   "fullname"
    t.string   "email"
    t.string   "start_path"
    t.boolean  "self_reg_confirmation_required"
    t.string   "confirmation_key"
    t.datetime "password_changed_at"
    t.boolean  "password_expired"
  end

  add_index "goldberg_users", ["role_id"], :name => "fk_user_role_id"

  create_table "pastpaths", :force => true do |t|
    t.integer  "song_id"
    t.string   "file"
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

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
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
    t.datetime "filemod"
    t.integer  "apid_id"
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
