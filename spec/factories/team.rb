FactoryGirl.define do
  factory :team do
    sequence(:name) {|n| "Team #{n}" }
    association :league
  end
end
