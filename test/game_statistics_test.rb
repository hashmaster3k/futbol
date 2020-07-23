require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'


class GameStatisticsTest < Minitest::Test
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

  def test_highest_total_score
    assert_equal 8, @stat_tracker.highest_total_score
  end

  def test_game_goals
    game1 = mock("game 1")
    game2 = mock("game 2")
    game1.stubs(:home_goals).returns(2)
    game1.stubs(:away_goals).returns(3)
    game2.stubs(:home_goals).returns(0)
    game2.stubs(:away_goals).returns(3)

    @stat_tracker.stubs(:games).returns([game1, game2])

    expected = [5,3]
    assert_equal expected, @stat_tracker.game_goals
  end
end
