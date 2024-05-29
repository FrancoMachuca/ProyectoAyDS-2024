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

ActiveRecord::Schema[7.1].define(version: 2024_05_20_220347) do
  create_table "exams", force: :cascade do |t|
    t.integer "minScore"
    t.integer "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["level_id"], name: "index_exams_on_level_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "help"
    t.integer "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["level_id"], name: "index_lessons_on_level_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiple_choices", force: :cascade do |t|
    t.integer "number_answer"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_multiple_choices_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "description"
    t.integer "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["level_id"], name: "index_questions_on_level_id"
  end

  create_table "to_completes", force: :cascade do |t|
    t.string "letters"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_to_completes_on_question_id"
  end

  create_table "translations", force: :cascade do |t|
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_translations_on_question_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.string "password"
    t.integer "totalScore"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_levels", force: :cascade do |t|
    t.integer "user_id"
    t.integer "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["level_id"], name: "index_users_levels_on_level_id"
    t.index ["user_id"], name: "index_users_levels_on_user_id"
  end

  create_table "users_questions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_users_questions_on_question_id"
    t.index ["user_id"], name: "index_users_questions_on_user_id"
  end

  add_foreign_key "exams", "levels"
  add_foreign_key "lessons", "levels"
  add_foreign_key "multiple_choices", "questions"
  add_foreign_key "questions", "levels"
  add_foreign_key "to_completes", "questions"
  add_foreign_key "translations", "questions"
  add_foreign_key "users_levels", "levels"
  add_foreign_key "users_levels", "users"
  add_foreign_key "users_questions", "questions"
  add_foreign_key "users_questions", "users"
end
