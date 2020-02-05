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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190329160313) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     :index=>{:name=>"index_active_admin_comments_on_namespace"}
    t.text     "body"
    t.string   "resource_id",   :null=>false
    t.string   "resource_type", :null=>false, :index=>{:name=>"index_active_admin_comments_on_resource_type_and_resource_id", :with=>["resource_id"]}
    t.string   "author_type",   :index=>{:name=>"index_active_admin_comments_on_author_type_and_author_id", :with=>["author_id"]}
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  :default=>"", :null=>false, :index=>{:name=>"index_admin_users_on_email", :unique=>true}
    t.string   "encrypted_password",     :default=>"", :null=>false
    t.string   "reset_password_token",   :index=>{:name=>"index_admin_users_on_reset_password_token", :unique=>true}
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default=>0, :null=>false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
  end

  create_table "approvals", force: :cascade do |t|
    t.integer  "camp_id",    :index=>{:name=>"index_approvals_on_camp_id"}
    t.integer  "user_id",    :index=>{:name=>"index_approvals_on_user_id"}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "budget_items", force: :cascade do |t|
    t.string   "description"
    t.integer  "amount"
    t.integer  "camp_id",     :index=>{:name=>"index_budget_items_on_camp_id"}
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "camps", force: :cascade do |t|
    t.string   "name",                                                     :limit=>64, :null=>false
    t.text     "subtitle",                                                 :limit=>255, :null=>false
    t.string   "contact_email",                                            :limit=>64
    t.string   "contact_name",                                             :limit=>64, :null=>false
    t.string   "contact_phone",                                            :limit=>64
    t.text     "description",                                              :limit=>4096
    t.text     "electricity",                                              :limit=>255
    t.text     "light",                                                    :limit=>512
    t.text     "fire",                                                     :limit=>512
    t.text     "noise",                                                    :limit=>255
    t.text     "nature",                                                   :limit=>255
    t.text     "moop",                                                     :limit=>512
    t.text     "plan",                                                     :limit=>1024
    t.text     "cocreation",                                               :limit=>1024
    t.text     "neighbors",                                                :limit=>512
    t.text     "budgetplan",                                               :limit=>1024
    t.integer  "minbudget"
    t.integer  "maxbudget"
    t.boolean  "seeking_members"
    t.integer  "user_id",                                                  :index=>{:name=>"index_camps_on_user_id"}
    t.boolean  "grantingtoggle",                                           :default=>false, :null=>false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "minfunded",                                                :default=>false
    t.boolean  "fullyfunded",                                              :default=>false
    t.text     "recycling",                                                :limit=>512
    t.integer  "minbudget_realcurrency"
    t.integer  "maxbudget_realcurrency"
    t.boolean  "active",                                                   :default=>true
    t.string   "about_the_artist",                                         :limit=>1024
    t.string   "website",                                                  :limit=>512
    t.boolean  "is_public",                                                :default=>true, :null=>false
    t.string   "google_drive_folder_path",                                 :limit=>512
    t.string   "google_drive_budget_file_path",                            :limit=>512
    t.string   "dreamscholarship_execution_potential_previous_experience", :limit=>4096
    t.string   "en_name",                                                  :limit=>64
    t.string   "en_subtitle",                                              :limit=>255
    t.string   "dream_point_of_contact_email",                             :limit=>64
    t.string   "safety_file_comments",                                     :limit=>4096
    t.string   "loomio_thread_id"
    t.string   "loomio_thread_key"
    t.string   "color"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id",    :index=>{:name=>"index_favorites_on_user_id"}
    t.integer  "camp_id",    :index=>{:name=>"index_favorites_on_camp_id"}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "flag_events", force: :cascade do |t|
    t.string   "flag_type"
    t.integer  "user_id",    :index=>{:name=>"index_flag_events_on_user_id"}
    t.integer  "camp_id",    :index=>{:name=>"index_flag_events_on_camp_id"}
    t.boolean  "value"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "grants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.integer  "amount"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size",    :limit=>8
    t.datetime "attachment_updated_at"
  end

  create_table "log_entries", force: :cascade do |t|
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
    t.string   "topic"
    t.string   "entry_type"
    t.integer  "user_id"
    t.string   "user_email"
    t.string   "user_name"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "description"
    t.boolean  "loomio_consumed", :default=>false
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.integer  "user_id",    :index=>{:name=>"index_memberships_on_user_id"}
    t.integer  "camp_id",    :index=>{:name=>"index_memberships_on_camp_id"}
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "background"
    t.datetime "created_at",          :null=>false
    t.datetime "updated_at",          :null=>false
    t.integer  "camp_id",             :null=>false, :index=>{:name=>"index_people_on_camp_id"}
    t.boolean  "has_ticket"
    t.boolean  "needs_early_arrival"
  end

  create_table "people_roles", force: :cascade do |t|
    t.integer "person_id", :index=>{:name=>"index_people_roles_on_person_id"}
    t.integer "role_id",   :index=>{:name=>"index_people_roles_on_role_id"}
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id",    :index=>{:name=>"index_roles_on_user_id"}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "safety_items", force: :cascade do |t|
    t.string   "headline"
    t.string   "information"
    t.integer  "camp_id",     :index=>{:name=>"index_safety_items_on_camp_id"}
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "safety_sketches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.datetime "created_at",              :null=>false
    t.datetime "updated_at",              :null=>false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.bigint   "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        :index=>{:name=>"index_taggings_on_tag_id"}
    t.string   "taggable_type", :index=>{:name=>"index_taggings_on_taggable_type"}
    t.integer  "taggable_id",   :index=>{:name=>"index_taggings_on_taggable_id"}
    t.string   "tagger_type"
    t.integer  "tagger_id",     :index=>{:name=>"index_taggings_on_tagger_id"}
    t.string   "context",       :limit=>128, :index=>{:name=>"index_taggings_on_context"}
    t.datetime "created_at"

    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name=>"taggings_idx", :unique=>true
    t.index ["taggable_id", "taggable_type", "context"], :name=>"index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], :name=>"taggings_idy"
    t.index ["tagger_id", "tagger_type"], :name=>"index_taggings_on_tagger_id_and_tagger_type"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name",           :index=>{:name=>"index_tags_on_name", :unique=>true}
    t.integer "taggings_count", :default=>0
  end

  create_table "tickets", force: :cascade do |t|
    t.text   "id_code"
    t.string "email",   :limit=>64, :default=>"", :null=>false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  :default=>"", :null=>false, :index=>{:name=>"index_users_on_email", :unique=>true}
    t.string   "encrypted_password",     :default=>"", :null=>false
    t.string   "reset_password_token",   :index=>{:name=>"index_users_on_reset_password_token", :unique=>true}
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default=>0, :null=>false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",             :null=>false
    t.datetime "updated_at",             :null=>false
    t.string   "provider"
    t.string   "uid"
    t.text     "ticket_id"
    t.boolean  "guide",                  :default=>false
    t.boolean  "admin",                  :default=>false
    t.integer  "grants",                 :default=>10
    t.string   "name"
    t.string   "avatar"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  :null=>false, :index=>{:name=>"index_versions_on_item_type_and_item_id", :with=>["item_id"]}
    t.integer  "item_id",    :null=>false
    t.string   "event",      :null=>false
    t.string   "whodunnit"
    t.text     "object",     :limit=>1073741823
    t.datetime "created_at"
  end

end
