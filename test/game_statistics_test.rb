require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'

MockGame = Struct.new(:season, :home_goals, :away_goals)
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
    game1 = MockGame.new(nil, 4, 6)
    game2 = MockGame.new(nil, 2, 2)
    game3 = MockGame.new(nil, 0, 3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 10, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    game1 = MockGame.new(nil, 4, 6)
    game2 = MockGame.new(nil, 2, 2)
    game3 = MockGame.new(nil, 0, 3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    game_team1 = MockGameTeam.new('home', 'LOSS')
    game_team2 = MockGameTeam.new('home', 'WIN')
    game_team3 = MockGameTeam.new('home', 'LOSS')
    game_team4 = MockGameTeam.new('home', 'WIN')
    game_team5 = MockGameTeam.new('away', 'WIN')
    game_team6 = MockGameTeam.new('away', 'WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 0.5, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team6
    ])

    assert_equal 0, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2,
      game_team4
    ])

    assert_equal 0.67, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    game_team1 = MockGameTeam.new('away', 'LOSS')
    game_team2 = MockGameTeam.new('away', 'WIN')
    game_team3 = MockGameTeam.new('away', 'LOSS')
    game_team4 = MockGameTeam.new('away', 'WIN')
    game_team5 = MockGameTeam.new('home', 'WIN')
    game_team6 = MockGameTeam.new('home', 'WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 0.5, @stat_tracker.percentage_visitor_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team6
    ])

    assert_equal 0, @stat_tracker.percentage_visitor_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2,
      game_team4
    ])

    assert_equal 0.67, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    game_team1 = MockGameTeam.new('away', 'TIE')
    game_team2 = MockGameTeam.new('away', 'TIE')
    game_team3 = MockGameTeam.new('away', 'LOSS')
    game_team4 = MockGameTeam.new('away', 'WIN')
    game_team5 = MockGameTeam.new('home', 'WIN')
    game_team6 = MockGameTeam.new('home', 'WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 1, @stat_tracker.percentage_ties

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team6
    ])

    assert_equal 0.5, @stat_tracker.percentage_ties

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team3,
      game_team6
    ])

    assert_equal 0.33, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    game1 = MockGame.new(20122013, nil, nil)
    game2 = MockGame.new(20122013, nil, nil)
    game3 = MockGame.new(20122013, nil, nil)
    game4 = MockGame.new(20132014, nil, nil)
    game5 = MockGame.new(20132014, nil, nil)
    game6 = MockGame.new(20142015, nil, nil)
    mock_games = [game1, game2, game3, game4]
    @stat_tracker.stubs(:games).returns(mock_games)

    expected = {"20122013" => 3, "20132014" => 2, "20142015" => 1}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_select_by_key_value
    game_team1 = MockGameTeam.new('home', 'WIN')
    game_team2 = MockGameTeam.new('home', 'LOSS')
    game_team3 = MockGameTeam.new('away', 'WIN')
    game_team4 = MockGameTeam.new('away', 'LOSS')
    mock_array = [game_team1, game_team2, game_team3, game_team4]

    assert_equal [game_team1, game_team2], @stat_tracker.select_by_key_value(mock_array, :hoa, "home")
    assert_equal [game_team3, game_team4], @stat_tracker.select_by_key_value(mock_array, :hoa, "away")
    assert_equal [game_team1, game_team3], @stat_tracker.select_by_key_value(mock_array, :result, "WIN")
    assert_equal [game_team2, game_team4], @stat_tracker.select_by_key_value(mock_array, :result, "LOSS")
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
