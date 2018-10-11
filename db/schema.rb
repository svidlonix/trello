# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_181_009_145_319) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'assignments', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'task_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[user_id task_id], name: 'index_assignments_on_user_id_and_task_id'
  end

  create_table 'comments', force: :cascade do |t|
    t.text 'body'
    t.integer 'user_id'
    t.integer 'task_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_at'], name: 'index_comments_on_created_at'
    t.index ['task_id'], name: 'index_comments_on_task_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'lists', force: :cascade do |t|
    t.string 'name'
    t.integer 'project_id'
    t.integer 'user_id'
    t.integer 'position'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['position'], name: 'index_lists_on_position'
    t.index ['project_id'], name: 'index_lists_on_project_id'
    t.index ['user_id'], name: 'index_lists_on_user_id'
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_projects_on_user_id'
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.integer 'project_id'
    t.integer 'user_id'
    t.integer 'task_parent_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'list_id'
    t.integer 'position'
    t.index ['list_id'], name: 'index_tasks_on_list_id'
    t.index ['position'], name: 'index_tasks_on_position'
    t.index ['project_id'], name: 'index_tasks_on_project_id'
    t.index ['task_parent_id'], name: 'index_tasks_on_task_parent_id'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end
