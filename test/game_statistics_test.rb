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
    mock_games = [game1, game2, game3, game4, game5, game6]
    @stat_tracker.stubs(:games).returns(mock_games)

    expected = {"20122013" => 3, "20132014" => 2, "20142015" => 1}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    game1 = MockGame.new(20122013, 3, 2)
    game2 = MockGame.new(20122013, 2, 1)
    game3 = MockGame.new(20122013, 4, 0)
    game4 = MockGame.new(20132014, 1, 1)
    game5 = MockGame.new(20132014, 1, 2)
    game6 = MockGame.new(20142015, 0, 3)
    mock_games1 = [game1, game2, game3, game4, game5, game6]
    mock_games2 = [game1, game2]
    mock_games3 = [game1, game5, game6]

    @stat_tracker.stubs(:games).returns(mock_games1)

    assert_equal 3.33, @stat_tracker.average_goals_per_game

    @stat_tracker.stubs(:games).returns(mock_games2)

    assert_equal 4, @stat_tracker.average_goals_per_game

    @stat_tracker.stubs(:games).returns(mock_games3)

    assert_equal 3.67, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    game1 = MockGame.new(20122013, 3, 2)
    game2 = MockGame.new(20122013, 2, 1)
    game3 = MockGame.new(20122013, 4, 0)
    game4 = MockGame.new(20132014, 1, 1)
    game5 = MockGame.new(20132014, 1, 2)
    game6 = MockGame.new(20142015, 0, 1)
    game7 = MockGame.new(20142015, 0, 1)
    game8 = MockGame.new(20142015, 0, 0)
    mock_games1 = [game1, game2, game3, game4, game5, game6, game7, game8] # 20 / 6 => 3.333?
    mock_games2 = [game1, game4]

    @stat_tracker.stubs(:games).returns(mock_games1)

    expected = {
      "20122013" => 4,
      "20132014" => 2.5,
      "20142015" => 0.67
    }

    assert_equal expected, @stat_tracker.average_goals_by_season

    @stat_tracker.stubs(:games).returns(mock_games2)

    expected = {
      "20122013" => 5,
      "20132014" => 2,
    }

    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_all_seasons
    game1 = MockGame.new(20122013, 3, 2)
    game2 = MockGame.new(20122013, 2, 1)
    game3 = MockGame.new(20122013, 4, 0)
    game4 = MockGame.new(20132014, 1, 1)
    game5 = MockGame.new(20132014, 1, 2)
    game6 = MockGame.new(20142015, 0, 3)

    mock_games = [game1, game2, game3, game4, game5, game6]

    @stat_tracker.stubs(:games).returns(mock_games)

    expected = ["20122013", "20132014", "20142015"]
    assert_equal expected, @stat_tracker.all_seasons
  end

  def test_games_goal_totals
    game1 = MockGame.new(nil, 2, 3)
    game2 = MockGame.new(nil, 0, 3)

    @stat_tracker.stubs(:games).returns([game1, game2])

    expected = [5,3]
    assert_equal expected, @stat_tracker.games_goal_totals(@stat_tracker.games)
  end

  def test_total_goals
    game = MockGame.new(nil, 2, 3)

    assert_equal 5, @stat_tracker.total_goals(game)
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
end
