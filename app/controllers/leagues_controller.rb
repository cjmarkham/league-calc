class LeaguesController < ApplicationController
  def show
    @league = League.find params[:id]
    @fixtures = Fixture.where(league: @league).order(played_at: :asc)
  end

  def table
    @league = League.find params[:id]
  end
end
