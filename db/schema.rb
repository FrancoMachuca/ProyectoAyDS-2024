# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 20_241_002_185_218) do
  create_table 'admins', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'answers', force: :cascade do |t|
    t.string 'answer'
    t.boolean 'correct'
    t.integer 'question_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['question_id'], name: 'index_answers_on_question_id'
  end

  create_table 'exams', force: :cascade do |t|
    t.integer 'minScore'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'falling_objects', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'images', force: :cascade do |t|
    t.string 'image', null: false
    t.string 'caption', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'lessons', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'levels', force: :cascade do |t|
    t.string 'name'
    t.integer 'playable_id'
    t.string 'playable_type'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'mouse_translations', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'multiple_choices', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'player_levels', force: :cascade do |t|
    t.integer 'player_id'
    t.integer 'level_id'
    t.integer 'playerLevelScore'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['level_id'], name: 'index_player_levels_on_level_id'
    t.index ['player_id'], name: 'index_player_levels_on_player_id'
  end

  create_table 'players', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'description'
    t.integer 'level_id'
    t.integer 'questionable_id'
    t.string 'questionable_type'
    t.integer 'times_answered_correctly', default: 0
    t.integer 'times_answered_incorrectly', default: 0
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['level_id'], name: 'index_questions_on_level_id'
  end

  create_table 'to_completes', force: :cascade do |t|
    t.string 'keyword'
    t.string 'toCompleteMorse'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'translations', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'tutorials', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'mail'
    t.string 'password'
    t.integer 'userable_id'
    t.string 'userable_type'
    t.integer 'image_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index ['image_id'], name: 'index_users_on_image_id'
  end

  add_foreign_key 'answers', 'questions'
  add_foreign_key 'player_levels', 'levels'
  add_foreign_key 'player_levels', 'players'
  add_foreign_key 'questions', 'levels'
  add_foreign_key 'users', 'images'
end
