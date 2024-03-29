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

ActiveRecord::Schema.define(version: 20170429125653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fixtures", force: :cascade do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "home_score",   default: 0
    t.integer  "away_score",   default: 0
    t.integer  "league_id"
    t.datetime "played_at"
    t.string   "status",       default: "pending"
    t.index ["away_team_id"], name: "index_fixtures_on_away_team_id", using: :btree
    t.index ["home_team_id"], name: "index_fixtures_on_home_team_id", using: :btree
    t.index ["league_id"], name: "index_fixtures_on_league_id", using: :btree
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string  "name"
    t.integer "league_id"
    t.integer "points",          default: 0
    t.integer "played",          default: 0
    t.integer "goals_for",       default: 0
    t.integer "goals_against",   default: 0
    t.integer "goal_difference", default: 0
    t.integer "wins",            default: 0
    t.integer "losses",          default: 0
    t.integer "draws",           default: 0
    t.string  "badge"
    t.index ["league_id"], name: "index_teams_on_league_id", using: :btree
  end

  add_foreign_key "fixtures", "teams", column: "away_team_id"
  add_foreign_key "fixtures", "teams", column: "home_team_id"
end
