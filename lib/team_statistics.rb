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

end
