class Initial < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.string :name
    end

    create_table :teams do |t|
      t.string :name
      t.references :league
      t.integer :points, default: 0
      t.integer :played, default: 0
      t.integer :goals_for, default: 0
      t.integer :goals_against, default: 0
      t.integer :goal_difference, default: 0
      t.integer :wins, default: 0
      t.integer :losses, default: 0
      t.integer :draws, default: 0
    end

    create_table :fixtures do |t|
      t.references :home_team, index: true, foreign_key: { to_table: :teams }
      t.references :away_team, index: true, foreign_key: { to_table: :teams }
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0
      t.references :league, index: true
      t.datetime :played_at
    end
  end
end
