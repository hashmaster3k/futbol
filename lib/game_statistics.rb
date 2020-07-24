module GameStatistics
  def highest_total_score
    game_goals.max
  end

  def lowest_total_score
    game_goals.min
  end

  def percentage_home_wins
    home_games = select_by_key_value(game_teams, :hoa, 'home')

    won_home_games = select_by_key_value(home_games, :result, 'WIN')

    (won_home_games.length.to_f / home_games.length).round(2)
  end

  def percentage_visitor_wins
    visitor_games = select_by_key_value(game_teams, :hoa, 'away')

    won_visitor_games = select_by_key_value(visitor_games, :result, 'WIN')

    (won_visitor_games.length.to_f / visitor_games.length).round(2)
  end

  def percentage_ties
    tied_games = select_by_key_value(game_teams, :result, 'TIE')

    (tied_games.length.to_f / game_teams.length).round(2)
  end

  def count_of_games_by_season
    initial_value = Hash.new { |h,k| h[k] = 0}
    games.reduce(initial_value) do |count_acc, game|
      season = game.season.to_s
      count_acc[season] += 1
      count_acc
    end
  end

  def average_goals_per_game
    (game_goals.sum.to_f / games.length).round(2)
  end

  def game_goals
    games.map do |game|
      game.home_goals + game.away_goals
    end
  end

  def select_by_key_value(array, key, value)
    array.select do |element|
      element.send(key) == value
    end
  end
end
