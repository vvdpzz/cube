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

ActiveRecord::Schema.define(:version => 20111008013931) do

  create_table "answers", :id => false, :force => true do |t|
    t.integer  "id",          :limit => 8,                           :null => false
    t.integer  "user_id",                                            :null => false
    t.string   "username",                                           :null => false
    t.string   "about_me",                        :default => ""
    t.integer  "question_id", :limit => 8,                           :null => false
    t.text     "content",                                            :null => false
    t.boolean  "is_correct",                      :default => false
    t.integer  "votes_count",                     :default => 0
    t.binary   "comments",    :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "credit_transactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "winner_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.boolean  "payment",      :default => true
    t.integer  "value"
    t.integer  "trade_type"
    t.integer  "trade_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_transactions", ["answer_id"], :name => "index_credit_transactions_on_answer_id"
  add_index "credit_transactions", ["question_id"], :name => "index_credit_transactions_on_question_id"
  add_index "credit_transactions", ["user_id"], :name => "index_credit_transactions_on_user_id"
  add_index "credit_transactions", ["winner_id"], :name => "index_credit_transactions_on_winner_id"

  create_table "follow_questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follow_questions", ["question_id"], :name => "index_follow_questions_on_question_id"
  add_index "follow_questions", ["user_id"], :name => "index_follow_questions_on_user_id"

  create_table "message_inboxes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "batch_id"
    t.integer  "message_id"
    t.string   "redis_mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "batch_id"
    t.integer  "sender_id"
    t.string   "sender_name"
    t.string   "sender_image"
    t.integer  "receiver_id"
    t.string   "receiver_name"
    t.string   "receiver_image"
    t.string   "title"
    t.text     "content"
    t.string   "redis_mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money_transactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "winner_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.decimal  "value",        :precision => 8, :scale => 2
    t.boolean  "payment",                                    :default => true
    t.integer  "trade_type"
    t.integer  "trade_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "money_transactions", ["answer_id"], :name => "index_money_transactions_on_answer_id"
  add_index "money_transactions", ["question_id"], :name => "index_money_transactions_on_question_id"
  add_index "money_transactions", ["user_id"], :name => "index_money_transactions_on_user_id"
  add_index "money_transactions", ["winner_id"], :name => "index_money_transactions_on_winner_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notif_type"
    t.string   "description"
    t.boolean  "read",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "questions", :id => false, :force => true do |t|
    t.integer  "id",                :limit => 8,                                                       :null => false
    t.integer  "user_id",                                                                              :null => false
    t.string   "title",                                                                                :null => false
    t.text     "content"
    t.integer  "credit",                                                              :default => 0
    t.decimal  "money",                                 :precision => 8, :scale => 2, :default => 0.0
    t.integer  "answers_count",                                                       :default => 0
    t.integer  "votes_count",                                                         :default => 0
    t.integer  "correct_answer_id",                                                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "comments",          :limit => 16777215
  end

  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "star_questions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "star_questions", ["question_id"], :name => "index_star_questions_on_question_id"
  add_index "star_questions", ["user_id"], :name => "index_star_questions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "realname"
    t.string   "username",                                                                             :null => false
    t.string   "authentication_token"
    t.string   "email",                                                               :default => "",  :null => false
    t.string   "encrypted_password",     :limit => 128,                               :default => "",  :null => false
    t.string   "about_me",                                                            :default => ""
    t.integer  "questions_count",                                                     :default => 0
    t.integer  "answers_count",                                                       :default => 0
    t.integer  "votes_count",                                                         :default => 0
    t.integer  "vote_per_day",                                                        :default => 40
    t.integer  "credit_today",                                                        :default => 0
    t.integer  "gpa",                                                                 :default => 0
    t.integer  "credit",                                                              :default => 0
    t.decimal  "money",                                 :precision => 8, :scale => 2, :default => 0.0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
