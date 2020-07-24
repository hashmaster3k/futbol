require_relative './game_teams_collection'
require_relative './games_collection'
require_relative './teams_collection'
require_relative './game_statistics'
require_relative './season_statistics'
require_relative './team_statistics'

class StatTracker
  include GameStatistics
  include SeasonStatistics
  include TeamStatistics
  attr_reader :game_teams, :games, :teams
  def initialize(game_teams, games, teams)
    @game_teams = game_teams
    @games = games
    @teams = teams
  end

  def self.from_csv(locations)
    game_teams = GameTeamsCollection.new(locations[:game_teams]).all_game_teams
    games = GamesCollection.new(locations[:games]).all_games
    teams = TeamsCollection.new(locations[:teams]).all_teams

    new(game_teams, games, teams)
  end
end
