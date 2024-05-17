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

ActiveRecord::Schema[7.1].define(version: 2024_05_15_224148) do
  create_table "exams", primary_key: "id_exam", force: :cascade do |t|
    t.integer "minScore"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", primary_key: "id_lesson", force: :cascade do |t|
    t.string "help"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", primary_key: "id_level", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multiple_choices", primary_key: "id_question", force: :cascade do |t|
    t.integer "number_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", primary_key: "id_question", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "to_completes", primary_key: "id_question", force: :cascade do |t|
    t.string "letters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translations", primary_key: "id_question", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.string "password"
    t.integer "totalScore"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
