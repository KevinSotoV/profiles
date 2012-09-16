# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120321173505) do

  create_table "friendships", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["profile_id"], :name => "index_friendships_on_profile_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "from_id"
    t.string   "method",     :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "headline",        :limit => 50
    t.string   "gender",          :limit => 1
    t.date     "birthday"
    t.text     "bio"
    t.string   "phone",           :limit => 50
    t.string   "location",        :limit => 50
    t.string   "small_image_url"
    t.string   "full_image_url"
    t.string   "facebook_id"
    t.string   "facebook_url"
    t.string   "twitter_id"
    t.string   "twitter_url"
    t.string   "workflow_state",                :default => "hidden"
    t.integer  "alerts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_since"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true
  add_index "profiles", ["workflow_state"], :name => "index_profiles_on_workflow_state"

  create_table "roles", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "group_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider",               :limit => 50
    t.string   "uid",                    :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 :default => "",               :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",               :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "workflow_state",                        :default => "pending_review"
    t.integer  "roles"
    t.string   "timezone",               :limit => 50
    t.string   "fb_token"
    t.boolean  "thirteen_or_older"
    t.integer  "notifications"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["roles"], :name => "index_users_on_roles"

end
