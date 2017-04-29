class FixturesController < ApplicationController

  include ActionView::Helpers::DateHelper

  def index
    @league = League.find params[:league_id]
    grouped = Fixture.where(league: @league)
                  .group_by_week(:played_at, series: false)
                  .order(played_at: :asc)
                  .group(:played_at)
                  .count


    @weeks = []
    grouped.each do |week|
      week_start = week[0][0]
      if ! @weeks.include?(week_start)
        @weeks.push(week_start)
      end
    end

    @current_week = Date.today.beginning_of_week(:sunday).strftime('%Y-%m-%d')
  end

  def weekly
    data = Fixture.where('played_at BETWEEN ? AND ?', Date.parse(params[:start]), Date.parse(params[:start]) + 7.days).order(played_at: :asc, id: :asc)

    fixtures = {}
    fixtures[:items] = {}

    data.each do |fixture|
      date = fixture.played_at.strftime('%A, %B %d')
      fixtures[:items][date] ||= []
      item = {
        id: fixture.id,
        home_team_name: fixture.home_team.name,
        away_team_name: fixture.away_team.name,
        home_won: fixture.home_score > fixture.away_score,
        away_won: fixture.home_score < fixture.away_score,
        home_team_score: fixture.home_score,
        away_team_score: fixture.away_score,
        home_badge: fixture.home_team.badge,
        away_badge: fixture.away_team.badge,
        time: fixture.played_at + 105.minutes,
        status: nil,
      }

      if Time.now > (fixture.played_at + 105.minutes)
        item[:status] = 'FT'
      elsif Time.now > fixture.played_at && Time.now < (fixture.played_at + 105.minutes)
        item[:status] = 'LIVE'
      else
        item[:status] = fixture.played_at.strftime('%l:%M %p')
      end

      fixtures[:items][date] << item
    end
    render json: fixtures
  end

  def new
    @league = League.find params[:league_id]
    @teams = Team.where(league: @league).order(name: :asc)
  end

  def create
    @teams = Team.all.order(name: :asc)
    # raise params.to_json

    params[:home_teams].each_with_index do |home_id, index|
      away_id = params[:away_teams][index]
      time = params[:times][index].split(':')
      date = DateTime.parse(params[:date]).change(hour: time[0].to_i, min: time[1].to_i, sec: 0)

      fixture = Fixture.create(
        league_id: params[:league_id].to_i,
        home_team_id: home_id,
        away_team_id: away_id,
        played_at: date,
        home_score: 0,
        away_score: 0,
      )

      if ! fixture.valid?
        flash.now[:error] = fixture.errors.full_messages.first
        render :new
        return
      end
    end

    flash[:success] = 'Fixtures created'
    redirect_to new_fixture_path(league_id: params[:league_id])
  end

  def update
    @fixture = Fixture.find params[:id]
    @fixture.update update_params

    if request.xhr?
      render json: {message: 'success'}, status: 200
    else
      redirect_to league_path(@fixture.league_id)
    end
  end

  private

  def update_params
    params.require(:fixture).permit(
      :home_score,
      :away_score,
    )
  end

end
