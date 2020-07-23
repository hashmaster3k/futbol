module LeagueStatistics

  def count_of_teams
    teams.count
  end

  def count_of_games_by_team_id(team_id)
    game_teams.find_all do |game_team|
      game_team.team_id == team_id
    end.count
  end






end
