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

ActiveRecord::Schema[8.1].define(version: 2026_07_10_110258) do
  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default_selected", default: false, null: false
    t.string "name"
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.boolean "uses_barbell", default: false, null: false
    t.index ["name"], name: "index_exercises_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "set_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "reps", null: false
    t.integer "set_number", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 2, null: false
    t.integer "workout_exercise_id", null: false
    t.index ["workout_exercise_id"], name: "index_set_entries_on_workout_exercise_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.integer "workout_session_id", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_session_id", "exercise_id"], name: "index_workout_exercises_on_workout_session_id_and_exercise_id", unique: true
    t.index ["workout_session_id"], name: "index_workout_exercises_on_workout_session_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "set_entries", "workout_exercises"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workout_sessions"
  add_foreign_key "workout_sessions", "users"
end
