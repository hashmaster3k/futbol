module LeagueStatistics

  def count_of_teams
    teams.count
  end

  def games_by_team_id(team_id)
    game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end
  end

  def count_of_goals_by_team_id(team_id)
    games_by_team_id(team_id).sum do |game|
      game.goals
    end
  end




end
