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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161226201331) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "camps", force: :cascade do |t|
    t.string   "name",                                                     limit: 64,                   null: false
    t.string   "subtitle",                                                 limit: 255,                  null: false
    t.string   "contact_email",                                            limit: 64,                   null: false
    t.string   "contact_name",                                             limit: 64,                   null: false
    t.string   "contact_phone",                                            limit: 64
    t.text     "description",                                              limit: 4096
    t.text     "electricity",                                              limit: 255
    t.text     "light",                                                    limit: 512
    t.text     "fire",                                                     limit: 512
    t.text     "noise",                                                    limit: 255
    t.text     "nature",                                                   limit: 255
    t.text     "moop",                                                     limit: 512
    t.text     "plan",                                                     limit: 1024
    t.text     "cocreation",                                               limit: 1024
    t.text     "neighbors",                                                limit: 512
    t.text     "budgetplan",                                               limit: 1024
    t.integer  "minbudget"
    t.integer  "maxbudget"
    t.boolean  "seeking_members"
    t.integer  "user_id"
    t.boolean  "grantingtoggle",                                                        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "minfunded",                                                             default: false
    t.boolean  "fullyfunded",                                                           default: false
    t.text     "recycling",                                                limit: 512
    t.integer  "minbudget_realcurrency"
    t.integer  "maxbudget_realcurrency"
    t.integer  "safetybag_crewsize"
    t.string   "safetybag_plan",                                           limit: 4096
    t.string   "safetybag_builder",                                        limit: 64
    t.string   "safetybag_safetyer",                                       limit: 64
    t.string   "safetybag_mooper",                                         limit: 64
    t.string   "safetybag_materials",                                      limit: 4096
    t.string   "safetybag_work_in_height",                                 limit: 4096
    t.string   "safetybag_tools",                                          limit: 4096
    t.string   "safetybag_grounding",                                      limit: 4096
    t.string   "safetybag_safety",                                         limit: 4096
    t.string   "safetybag_electricity",                                    limit: 4096
    t.string   "safetybag_daily_routine",                                  limit: 4096
    t.string   "safetybag_other_comments",                                 limit: 4096
    t.string   "safetybag_firstMemberName",                                limit: 64
    t.string   "safetybag_firstMemberEmail",                               limit: 64
    t.string   "safetybag_secondMemberName",                               limit: 64
    t.string   "safetybag_secondMemberEmail",                              limit: 64
    t.string   "dreamprop_philosophy",                                     limit: 4096
    t.string   "dreamprop_inspiration",                                    limit: 4096
    t.string   "dreamprop_interactivity_audience_participation",           limit: 4096
    t.boolean  "dreamprop_interactivity_is_fire_present",                               default: false, null: false
    t.string   "dreamprop_interactivity_fire_present_desc",                limit: 4096
    t.boolean  "dreamprop_interactivity_is_sound",                                      default: false, null: false
    t.string   "dreamprop_interactivity_sound_desc",                       limit: 4096
    t.boolean  "dreamprop_interactivity_is_fire_event",                                 default: false, null: false
    t.string   "dreamprop_interactivity_fire_event_desc",                  limit: 4096
    t.boolean  "dreamprop_community_is_installation_present_for_event",                 default: false, null: false
    t.boolean  "dreamprop_community_is_installation_present_for_public",                default: false, null: false
    t.boolean  "dreamprop_community_is_context",                                        default: false, null: false
    t.string   "dreamprop_community_context_desc",                         limit: 4096
    t.boolean  "dreamprop_community_is_interested_in_publicity",                        default: false, null: false
    t.boolean  "dreamprop_theme_is_annual",                                             default: false, null: false
    t.string   "dreamprop_theme_annual_desc",                              limit: 4096
    t.boolean  "active",                                                                default: true
    t.string   "about_the_artist",                                         limit: 1024
    t.string   "website",                                                  limit: 512
    t.boolean  "is_public",                                                             default: true,  null: false
    t.string   "spec_physical_description",                                limit: 4096
    t.string   "spec_length",                                              limit: 128
    t.string   "spec_width",                                               limit: 128
    t.string   "spec_height",                                              limit: 128
    t.string   "spec_visual_night_day",                                    limit: 4096
    t.boolean  "spec_is_electricity",                                                   default: false, null: false
    t.string   "spec_electricity_details",                                 limit: 4096
    t.string   "spec_electricity_how",                                     limit: 4096
    t.boolean  "spec_electricity_is_daytime",                                           default: false, null: false
    t.string   "spec_electricity_watt",                                    limit: 512
    t.boolean  "safety_is_heavy_equipment",                                             default: false, null: false
    t.string   "safety_equipment",                                         limit: 4096
    t.string   "safety_how_to_build_safety",                               limit: 4096
    t.string   "safety_how",                                               limit: 4096
    t.string   "safety_grounding",                                         limit: 4096
    t.string   "safety_securing",                                          limit: 4096
    t.string   "safety_securing_parts",                                    limit: 4096
    t.string   "safety_signs",                                             limit: 4096
    t.string   "program_dream_name_he",                                    limit: 256
    t.string   "program_dream_name_en",                                    limit: 256
    t.string   "program_dreamer_name_he",                                  limit: 256
    t.string   "program_dreamer_name_en",                                  limit: 256
    t.string   "program_dream_about_he",                                   limit: 4096
    t.string   "program_dream_about_en",                                   limit: 4096
    t.string   "program_special_activity",                                 limit: 4096
    t.string   "location_info",                                            limit: 1024
    t.string   "google_drive_folder_path",                                 limit: 512
    t.string   "google_drive_gaunt_file_path",                             limit: 512
    t.string   "google_drive_budget_file_path",                            limit: 512
    t.boolean  "dreamscholarship_fund_is_from_art_fund",                                default: false, null: false
    t.boolean  "dreamscholarship_fund_is_open_for_public",                              default: false, null: false
    t.integer  "dreamscholarship_budget_min_original",                                  default: 0
    t.integer  "dreamscholarship_budget_max_original",                                  default: 0
    t.string   "dreamscholarship_budget_max_original_desc",                limit: 4096
    t.string   "dreamscholarship_bank_account_info",                       limit: 128
    t.boolean  "dreamscholarship_financial_conduct_is_intial_budget",                   default: false, null: false
    t.string   "dreamscholarship_financial_conduct_intial_budget_desc",    limit: 4096
    t.string   "dreamscholarship_financial_conduct_money_raise_desc",      limit: 4096
    t.string   "dreamscholarship_execution_potential_previous_experience", limit: 4096
    t.string   "dreamscholarship_execution_potential_work_plan",           limit: 4096
  end

  add_index "camps", ["user_id"], name: "index_camps_on_user_id"

  create_table "grants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "camp_id"
  end

  add_index "memberships", ["camp_id"], name: "index_memberships_on_camp_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "background"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "camp_id",      null: false
  end

  add_index "people", ["camp_id"], name: "index_people_on_camp_id"

  create_table "responsibles", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "person_id"
    t.integer  "camp_id"
    t.string   "responsibility_type", null: false
  end

  add_index "responsibles", ["camp_id"], name: "index_responsibles_on_camp_id"
  add_index "responsibles", ["person_id"], name: "index_responsibles_on_person_id"

  create_table "tickets", force: :cascade do |t|
    t.text   "id_code"
    t.string "email",   limit: 64, default: "", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.text     "ticket_id"
    t.boolean  "guide",                  default: false
    t.boolean  "admin",                  default: false
    t.integer  "grants",                 default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
