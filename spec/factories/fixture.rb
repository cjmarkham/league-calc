FactoryGirl.define do
  factory :fixture do
    association :home_team, factory: :team
    association :away_team, factory: :team
    association :league
    home_score 0
    away_score 0
    played_at DateTime.now
  end
end
