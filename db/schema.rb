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

ActiveRecord::Schema.define(:version => 20120615212923) do

  create_table "canned_tweets", :force => true do |t|
    t.string   "description"
    t.string   "text"
    t.string   "tweet_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "canned_tweets", ["tweet_type"], :name => "index_canned_tweets_on_tweet_type"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "doghouses", :force => true do |t|
    t.integer  "user_id"
    t.string   "screen_name"
    t.boolean  "is_released"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "duration_minutes"
    t.integer  "job_id"
    t.string   "enter_tweet"
    t.string   "exit_tweet"
    t.integer  "request_from_twitter_id"
    t.string   "profile_image"
  end

  add_index "doghouses", ["request_from_twitter_id"], :name => "index_doghouses_on_request_from_twitter_id"
  add_index "doghouses", ["user_id"], :name => "index_doghouses_on_user_id"

  create_table "request_from_twitters", :force => true do |t|
    t.string   "tweet_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "request_from_twitters", ["user_id"], :name => "index_request_from_twitters_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "secret"
    t.string   "nickname"
    t.string   "image"
  end

  add_index "users", ["nickname"], :name => "index_users_on_nickname"

end
