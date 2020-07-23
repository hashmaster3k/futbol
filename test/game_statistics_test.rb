require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'

MockGame = Struct.new(:home_goals, :away_goals)

class GameStatisticsTest < Minitest::Test
  def setup
    locations = {
      games: 'no path',
      teams: 'no path',
      game_teams: 'no path'
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_highest_total_score
    game1 = MockGame.new(4, 6)
    game2 = MockGame.new(2, 2)
    game3 = MockGame.new(0, 3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 10, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    game1 = MockGame.new(4, 6)
    game2 = MockGame.new(2, 2)
    game3 = MockGame.new(0, 3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 3, @stat_tracker.lowest_total_score
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
