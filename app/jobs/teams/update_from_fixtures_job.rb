class Teams::UpdateFromFixturesJob < ApplicationJob
  def perform
    Team.find_each(batch_size: 10) do |team|
      update_team team
    end
  end

  private

  def update_team team
    home_fixtures = team.home_fixtures.complete
    away_fixtures = team.away_fixtures.complete

    if home_fixtures.count == 0 && away_fixtures.count == 0
      return
    end

    puts "UPDATING #{team.name}"
    puts "HOME FIXTURES: #{home_fixtures.count}"
    puts "AWAY FIXTURES: #{away_fixtures.count}"

    attributes = {
      played: 0,
      wins: 0,
      draws: 0,
      losses: 0,
      goals_for: 0,
      goals_against: 0,
      goal_difference: 0,
      points: 0,
    }

    home_fixtures.each do |fixture|
      attributes[:played] += 1

      if fixture.home_score > fixture.away_score
        attributes[:wins] += 1
        attributes[:points] += 3
      elsif fixture.home_score < fixture.away_score
        attributes[:losses] += 1
      else
        attributes[:draws] += 1
        attributes[:points] += 1
      end

      attributes[:goals_for] += fixture.home_score
      attributes[:goals_against] += fixture.away_score
    end

    away_fixtures.each do |fixture|
      attributes[:played] += 1

      if fixture.away_score > fixture.home_score
        attributes[:wins] += 1
        attributes[:points] += 3
      elsif fixture.away_score < fixture.home_score
        attributes[:losses] += 1
      else
        attributes[:draws] += 1
        attributes[:points] += 1
      end

      attributes[:goals_for] += fixture.away_score
      attributes[:goals_against] += fixture.home_score
    end

    attributes[:goal_difference] = attributes[:goals_for] - attributes[:goals_against]

    if team.update attributes
      puts "SAVED!"
      puts attributes.to_yaml
    else
      puts 'ERROR!'
    end
  end
end
