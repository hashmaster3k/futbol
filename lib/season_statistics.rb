module SeasonStatistics

  def games_from_season(season_id)
    game_teams.find_all do |game_team|
      game_team.game_id.to_s[0...4] == season_id[0...4]
    end
  end

  def group_wins_by_coach(season_id)
    games_from_season(season_id).group_by {|game| game.head_coach}
    # returns {coach: [game1, game2, etc.]} per team
  end

  def win_percentages_per_coach(season_id)
    win_percent = Hash.new(0)
    group_wins_by_coach(season_id).each do |coach, array_games|
      total_wins = 0
      total_games = 0
      array_games.each do |game|
        total_wins += 1 if game.result == "WIN"
        total_games += 1
      end
      win_percent[coach] = (total_wins.to_f / total_games).round(3)
    end
    win_percent
  end

	# Name of the coach with the best win percentage for the season
  def winningest_coach(season_id)
    win_percentages_per_coach(season_id).max_by {|coach, win_percentage| win_percentage}[0]
  end

  #	Name of the coach with the worst win percentage for the season
  def worst_coach(season_id)
    win_percentages_per_coach(season_id).min_by {|coach, win_percentage| win_percentage}[0]
  end

  def group_by_teams(season_id)
    games_from_season(season_id).group_by {|game| game.team_id}
    # returns {team_id: [game1, game2, etc.]} per team
  end

  def accuracy_per_team(season_id)
    acc_per_team = Hash.new(0)
    group_by_teams(season_id).each do |t_id, games|
      total_shots = 0
      total_goals = 0
      games.each do |game|
        total_shots += game.shots
        total_goals += game.goals
      end
      acc_per_team[t_id] = (total_goals.to_f / total_shots).round(4)
    end
    acc_per_team
  end

  # Name of the team with the best ratio of shots to goals for the season
  def most_accurate_team(season_id)
    acc_team_id = accuracy_per_team(season_id).max_by {|team, accuracy| accuracy}[0]
    teams.find {|team| team.team_id.to_i == acc_team_id}.teamname
  end

  # Name of the team with the worst ratio of shots to goals for the season
  def least_accurate_team(season_id)
    acc_team_id = accuracy_per_team(season_id).min_by {|team, accuracy| accuracy}[0]
    teams.find {|team| team.team_id.to_i == acc_team_id}.teamname
  end

end
