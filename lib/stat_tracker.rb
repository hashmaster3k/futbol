require_relative './game_team'
require_relative './game'
require_relative './team'
require_relative './game_statistics'
require_relative './season_statistics'
require_relative './league_statistics'
require_relative './team_statistics'

class StatTracker
  include GameStatistics
  include SeasonStatistics
  include LeagueStatistics
  include TeamStatistics
  attr_reader :game_teams, :games, :teams
  def initialize(game_teams, games, teams)
    @game_teams = game_teams
    @games = games
    @teams = teams
  end

  def self.from_csv(locations)
    game_teams = GameTeam.create_game_teams(locations[:game_teams])
    games = Game.create_games(locations[:games])
    teams = Team.create_teams(locations[:teams])

    new(game_teams, games, teams)
  end
end
