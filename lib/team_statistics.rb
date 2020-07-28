require 'pry';
module TeamStatistics

  def create_team_hash(team)
    {"team_id"      => team.team_id,
     "franchise_id" => team.franchiseid,
     "team_name"    => team.teamname,
     "abbreviation" => team.abbreviation,
     "link"         => team.link}
  end

  def find_team(team_id)
    teams.find { |team| team.team_id == team_id }
  end

  #	A hash with key/value pairs for the following attributes: team_id, franchise_id, team_name, abbreviation, and link
  def team_info(team_id)
    create_team_hash(find_team(team_id))
  end

  def get_all_games_from_team(team_id)
    game_teams.find_all {|game_team| game_team.team_id == team_id.to_i}
  end

  def group_by_season(team_id)
    get_all_games_from_team(team_id).group_by {|game| game.game_id.to_s[0...4]}
  end

  def win_percent_per_season(team_id)
    win_percent = Hash.new(0)
    group_by_season(team_id).each do |season, array_games|
      total_wins  = 0
      total_games = 0
      array_games.each do |game|
        total_wins  += 1 if game.result == "WIN"
        total_games += 1
      end
      win_percent[season] = (total_wins.to_f / total_games).round(3)
    end
    win_percent
  end

  def get_full_season(winning_season)
    "#{winning_season[0].to_i}201#{winning_season[0].to_i.digits.reverse[3] + 1}"
  end

  # Season with the highest win percentage for a team.
  def best_season(team_id)
    winning_season = win_percent_per_season(team_id).max_by {|season, win_percent| win_percent}
    get_full_season(winning_season)
  end

  # Season with the lowest win percentage for a team.
  def worst_season(team_id)
    losing_season = win_percent_per_season(team_id).min_by {|season, win_percent| win_percent}
    get_full_season(losing_season)
  end

  # Average win percentage of all games for a team.
  def average_win_percentage(team_id)
    all_percents = []
    win_percent_per_season(team_id).each {|season, win_percentage| all_percents << win_percentage}
    all_percents.sum / all_percents.length
  end

  # Highest number of goals a particular team has scored in a single game.
  def most_goals_scored(team_id)
    get_all_games_from_team(team_id).max_by do |game|
      game.goals
    end.goals
  end

  # Lowest numer of goals a particular team has scored in a single game.
  def fewest_goals_scored(team_id)
    get_all_games_from_team(team_id).min_by do |game|
      game.goals
    end.goals
  end

  def favorite_opponent(team_id)
    rival_id = opponent_win_count(team_id).sort_by { |k, v| v[:average] }.first[0]
    rival_team = find_team(rival_id.to_s)
    rival_team.teamname
  end

  def rival(team_id)
    rival_id = opponent_win_count(team_id).sort_by {|k, v| v[:average]}.last[0]
    rival_team = find_team(rival_id.to_s)
    rival_team.teamname
  end

  def opponent_win_count(team_id)
    team_id = team_id.to_i
    initial_value = Hash.new { |h,k| h[k] = {wins: 0, total: 0, average: 0}}
    games.reduce(initial_value) do |opponent_win_count, game|
      if this_game_matters?(game, team_id)
        opponent_id = get_opponent_id(game, team_id)
        change_opponent_count(game, opponent_id, opponent_win_count)
      end
      opponent_win_count
    end
  end

  def change_opponent_count(game, opponent_id, opponent_win_count)
    if opponent_won?(game, opponent_id)
      opponent_win_count[opponent_id][:wins] += 1
    end
    opponent_win_count[opponent_id][:total] += 1
    opponent_win_count[opponent_id][:average] = (opponent_win_count[opponent_id][:wins].to_f / opponent_win_count[opponent_id][:total]).round(2)
  end

  def get_opponent_id(game, team_id)
    if game.home_team_id == team_id
      game.away_team_id
    else
      game.home_team_id
    end
  end

  def this_game_matters?(game, team_id)
    game.home_team_id == team_id || game.away_team_id == team_id
  end

  def opponent_away?(game, opponent_id)
    game.away_team_id == opponent_id
  end

  def opponent_won? (game, opponent_id)
    if opponent_away?(game, opponent_id)
      game.away_goals > game.home_goals
    else
      game.away_goals < game.home_goals
    end
  end
end
