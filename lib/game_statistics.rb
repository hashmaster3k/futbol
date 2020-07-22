module GameStatistics
  def highest_total_score
    game_goals.max
  end

  def game_goals
    games.map do |game|
      game.home_goals + game.away_goals
    end
  end
end
