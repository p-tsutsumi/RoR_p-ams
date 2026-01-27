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

ActiveRecord::Schema[7.1].define(version: 2026_01_26_234802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.string "user_id"
    t.date "working_date"
    t.datetime "clock_in_at"
    t.datetime "clock_out_at"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "work_category", default: 0, null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
    t.index ["working_date"], name: "index_attendances_on_working_date"
  end

  create_table "break_times", force: :cascade do |t|
    t.bigint "attendance_id", null: false
    t.integer "break_type"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_break_times_on_attendance_id"
  end

  add_foreign_key "break_times", "attendances"
end
