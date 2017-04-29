class AddBadgeToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :badge, :string
  end
end
