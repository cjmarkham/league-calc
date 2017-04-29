class Fixture < ApplicationRecord
  belongs_to :home_team, class_name: :Team
  belongs_to :away_team, class_name: :Team

  belongs_to :league

  after_commit :update_teams

  scope :complete, -> do
    where('played_at < ?', DateTime.now + 105.minutes)
  end

  def update_teams
    Teams::UpdateFromFixturesJob.perform_later
  end
end
