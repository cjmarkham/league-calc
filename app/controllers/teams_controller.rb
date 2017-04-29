class TeamsController < ApplicationController
  def update
    team = Team.find params[:id]
    team.update update_params

    if request.xhr?
      render json: {message: 'success'}, status: 200
    end
  end

  private

  def update_params
    params.require(:team).permit(
      :played,
      :wins,
      :draws,
      :losses,
      :goals_for,
      :goals_against,
      :goal_difference,
      :points,
    )
  end
end
