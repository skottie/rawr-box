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

ActiveRecord::Schema.define(:version => 20120706190718) do

  create_table "commits", :force => true do |t|
    t.string   "team_handle"
    t.string   "changeset"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "branch"
  end

  create_table "configuration_values", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrases", :force => true do |t|
    t.string   "phrase"
    t.string   "voice"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redmine_tickets", :force => true do |t|
    t.integer  "project_id"
    t.integer  "ticket_id"
    t.datetime "ticket_created_at"
    t.string   "assigned_to"
    t.string   "author_name"
    t.string   "subject"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ticket_status"
  end

  add_index "redmine_tickets", ["ticket_status"], :name => "index_redmine_tickets_on_ticket_status"

  create_table "sounds", :force => true do |t|
    t.string   "path"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename"
  end

end
