class Team < ApplicationRecord
  belongs_to :league

  has_many :home_fixtures, class_name: :Fixture, foreign_key: :home_team
  has_many :away_fixtures, class_name: :Fixture, foreign_key: :away_team
end
