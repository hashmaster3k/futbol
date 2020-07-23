module LeagueStatistics

  def count_of_teams
    teams.count
  end

  def unique_teams
    team_id = game_teams.uniq { |game_team| game_team.team_id }
    team_id.map do |game_team|
      game_team.team_id
    end
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

  def average_goals_per_season(team_id)
    count_of_goals_by_team_id(team_id).to_f / games_by_team_id(team_id).count.round(2)
  end

  def best_offense
    best_offense = unique_teams.sort_by do |team_id|
      average_goals_per_season(team_id)
    end
    teams.find do |team|
      team.team_id == best_offense.last.to_s
    end.teamname
  end

  def worst_offense
    worst_offense = unique_teams.sort_by do |team_id|
      average_goals_per_season(team_id)
    end
    teams.find do |team|
      team.team_id == worst_offense.first.to_s
    end.teamname
  end

  def away_games_by_team_id(team_id)
    game_teams.find_all do |game_team|
      game_team.team_id == team_id if game_team.hoa == "away"
    end
  end

  def away_count_of_goals_by_team_id(team_id)
    away_games_by_team_id(team_id).sum do |game|
      game.goals
    end
  end

  def average_goals_per_game_when_away(team_id)
    away_count_of_goals_by_team_id(team_id).to_f / away_games_by_team_id(team_id).count.round(2)
  end

end
