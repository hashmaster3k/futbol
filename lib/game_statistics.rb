module GameStatistics
  def highest_total_score
    game_goals.max
  end

  def game_goals
    games.map do |game|
      game.home_goals + game.away_goals
    end
  end

  def percentage_home_wins
    home_games = select_by_key_value(game_teams, :hoa, 'home')

    won_home_games = select_by_key_value(home_games, :result, 'WIN')

    (won_home_games.length.to_f / home_games.length).round(2)
  end

  def select_by_key_value(array, key, value)
    array.select do |element|
      element[key] == value
    end
  end
end
