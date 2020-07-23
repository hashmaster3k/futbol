require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'

MockGame = Struct.new(:home_goals, :away_goals)
MockGameTeam = Struct.new(:hoa, :result)

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

  def test_percentage_home_wins
    gameteam1 = MockGameTeam.new('home', 'LOSS')
    gameteam2 = MockGameTeam.new('home', 'WIN')
    gameteam3 = MockGameTeam.new('home', 'LOSS')
    gameteam4 = MockGameTeam.new('home', 'WIN')
    gameteam5 = MockGameTeam.new('away', 'WIN')
    gameteam6 = MockGameTeam.new('away', 'WIN')

    @stat_tracker.stubs(:game_teams).returns([
      gameteam1,
      gameteam2
    ])

    assert_equal 0.5, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      gameteam1,
      gameteam6
    ])

    assert_equal 0, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      gameteam1,
      gameteam2,
      gameteam4
    ])

    assert_equal 0.67, @stat_tracker.percentage_home_wins
  end

  def test_select_by_key_value
    mock_element1 = {happy: true, hungry: false}
    mock_element2 = {happy: false, hungry: true}
    mock_element3 = {happy: false, hungry: false}
    mock_array = [mock_element1, mock_element2, mock_element3]

    assert_equal [mock_element1], @stat_tracker.select_by_key_value(mock_array, :happy, true)
    assert_equal [mock_element2], @stat_tracker.select_by_key_value(mock_array, :hungry, true)
    assert_equal [mock_element2, mock_element3], @stat_tracker.select_by_key_value(mock_array, :happy, false)
    assert_equal [mock_element1, mock_element3], @stat_tracker.select_by_key_value(mock_array, :hungry, false)
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
