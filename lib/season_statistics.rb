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

end
