require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class LeagueStatisticsTest < Minitest::Test

  def setup
    game_path = './test/fixtures/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './test/fixtures/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  # def test_highest_total_score
  #   assert_equal 8, @stat_tracker.highest_total_score
  # end

  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end
end
