require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/stat_tracker'

# Data Used
# Game :season :home_goals :away_goals
# GameTeam :hoa :result

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
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game1.stubs(:home_goals).returns(4)
    game1.stubs(:away_goals).returns(6)
    game2.stubs(:home_goals).returns(2)
    game2.stubs(:away_goals).returns(2)
    game3.stubs(:home_goals).returns(0)
    game3.stubs(:away_goals).returns(3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 10, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game1.stubs(:home_goals).returns(4)
    game1.stubs(:away_goals).returns(6)
    game2.stubs(:home_goals).returns(2)
    game2.stubs(:away_goals).returns(2)
    game3.stubs(:home_goals).returns(0)
    game3.stubs(:away_goals).returns(3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    game_team1 = mock('game_team1')
    game_team2 = mock('game_team2')
    game_team3 = mock('game_team3')
    game_team4 = mock('game_team4')
    game_team1.stubs(:hoa).returns('home')
    game_team1.stubs(:result).returns('LOSS')
    game_team2.stubs(:hoa).returns('home')
    game_team2.stubs(:result).returns('WIN')
    game_team3.stubs(:hoa).returns('home')
    game_team3.stubs(:result).returns('WIN')
    game_team4.stubs(:hoa).returns('away')
    game_team4.stubs(:result).returns('WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 0.5, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team4
    ])

    assert_equal 0, @stat_tracker.percentage_home_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2,
      game_team3
    ])

    assert_equal 0.67, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    game_team1 = mock('game_team1')
    game_team2 = mock('game_team2')
    game_team3 = mock('game_team3')
    game_team4 = mock('game_team4')
    game_team1.stubs(:hoa).returns('away')
    game_team1.stubs(:result).returns('LOSS')
    game_team2.stubs(:hoa).returns('away')
    game_team2.stubs(:result).returns('WIN')
    game_team3.stubs(:hoa).returns('away')
    game_team3.stubs(:result).returns('WIN')
    game_team4.stubs(:hoa).returns('home')
    game_team4.stubs(:result).returns('WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 0.5, @stat_tracker.percentage_visitor_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team4
    ])

    assert_equal 0, @stat_tracker.percentage_visitor_wins

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2,
      game_team3
    ])

    assert_equal 0.67, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    game_team1 = mock('game_team1')
    game_team2 = mock('game_team2')
    game_team3 = mock('game_team3')
    game_team4 = mock('game_team4')
    game_team1.stubs(:hoa).returns('away')
    game_team1.stubs(:result).returns('TIE')
    game_team2.stubs(:hoa).returns('away')
    game_team2.stubs(:result).returns('TIE')
    game_team3.stubs(:hoa).returns('away')
    game_team3.stubs(:result).returns('LOSS')
    game_team4.stubs(:hoa).returns('home')
    game_team4.stubs(:result).returns('WIN')

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team2
    ])

    assert_equal 1, @stat_tracker.percentage_ties

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team4
    ])

    assert_equal 0.5, @stat_tracker.percentage_ties

    @stat_tracker.stubs(:game_teams).returns([
      game_team1,
      game_team3,
      game_team4
    ])

    assert_equal 0.33, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game4 = mock('game4')
    game5 = mock('game5')
    game6 = mock('game6')
    game1.stubs(:season).returns(20122013)
    game2.stubs(:season).returns(20122013)
    game3.stubs(:season).returns(20122013)
    game4.stubs(:season).returns(20132014)
    game5.stubs(:season).returns(20132014)
    game6.stubs(:season).returns(20142015)
    games = [game1, game2, game3, game4, game5, game6]
    @stat_tracker.stubs(:games).returns(games)

    expected = {"20122013" => 3, "20132014" => 2, "20142015" => 1}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game4 = mock('game4')
    game5 = mock('game5')
    game6 = mock('game6')
    game1.stubs(:season).returns(20122013)
    game1.stubs(:home_goals).returns(3)
    game1.stubs(:away_goals).returns(2)
    game2.stubs(:season).returns(20122013)
    game2.stubs(:home_goals).returns(2)
    game2.stubs(:away_goals).returns(1)
    game3.stubs(:season).returns(20122013)
    game3.stubs(:home_goals).returns(4)
    game3.stubs(:away_goals).returns(0)
    game4.stubs(:season).returns(20132014)
    game4.stubs(:home_goals).returns(1)
    game4.stubs(:away_goals).returns(1)
    game5.stubs(:season).returns(20132014)
    game5.stubs(:home_goals).returns(1)
    game5.stubs(:away_goals).returns(2)
    game6.stubs(:season).returns(20142015)
    game6.stubs(:home_goals).returns(0)
    game6.stubs(:away_goals).returns(3)
    games1 = [game1, game2, game3, game4, game5, game6]
    games2 = [game1, game2]
    games3 = [game1, game5, game6]

    @stat_tracker.stubs(:games).returns(games1)

    assert_equal 3.33, @stat_tracker.average_goals_per_game

    @stat_tracker.stubs(:games).returns(games2)

    assert_equal 4, @stat_tracker.average_goals_per_game

    @stat_tracker.stubs(:games).returns(games3)

    assert_equal 3.67, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game4 = mock('game4')
    game5 = mock('game5')
    game6 = mock('game6')
    game7 = mock('game7')
    game8 = mock('game8')
    game1.stubs(:season).returns(20122013)
    game1.stubs(:home_goals).returns(3)
    game1.stubs(:away_goals).returns(2)
    game2.stubs(:season).returns(20122013)
    game2.stubs(:home_goals).returns(2)
    game2.stubs(:away_goals).returns(1)
    game3.stubs(:season).returns(20122013)
    game3.stubs(:home_goals).returns(4)
    game3.stubs(:away_goals).returns(0)
    game4.stubs(:season).returns(20132014)
    game4.stubs(:home_goals).returns(1)
    game4.stubs(:away_goals).returns(1)
    game5.stubs(:season).returns(20132014)
    game5.stubs(:home_goals).returns(1)
    game5.stubs(:away_goals).returns(2)
    game6.stubs(:season).returns(20142015)
    game6.stubs(:home_goals).returns(0)
    game6.stubs(:away_goals).returns(1)
    game7.stubs(:season).returns(20142015)
    game7.stubs(:home_goals).returns(0)
    game7.stubs(:away_goals).returns(1)
    game8.stubs(:season).returns(20142015)
    game8.stubs(:home_goals).returns(0)
    game8.stubs(:away_goals).returns(0)
    games1 = [game1, game2, game3, game4, game5, game6, game7, game8]
    games2 = [game1, game4]

    @stat_tracker.stubs(:games).returns(games1)

    expected = {
      "20122013" => 4,
      "20132014" => 2.5,
      "20142015" => 0.67
    }

    assert_equal expected, @stat_tracker.average_goals_by_season

    @stat_tracker.stubs(:games).returns(games2)

    expected = {
      "20122013" => 5,
      "20132014" => 2,
    }

    assert_equal expected, @stat_tracker.average_goals_by_season
  end

  def test_all_seasons
    game1 = mock('game1')
    game2 = mock('game2')
    game3 = mock('game3')
    game4 = mock('game4')
    game5 = mock('game5')
    game6 = mock('game6')
    game1.stubs(:season).returns(20122013)
    game2.stubs(:season).returns(20122013)
    game3.stubs(:season).returns(20122013)
    game4.stubs(:season).returns(20132014)
    game5.stubs(:season).returns(20132014)
    game6.stubs(:season).returns(20142015)

    games = [game1, game2, game3, game4, game5, game6]

    @stat_tracker.stubs(:games).returns(games)

    expected = ["20122013", "20132014", "20142015"]
    assert_equal expected, @stat_tracker.all_seasons
  end

  def test_games_goal_totals
    game1 = mock('game1')
    game2 = mock('game2')
    game1.stubs(:home_goals).returns(2)
    game1.stubs(:away_goals).returns(3)
    game2.stubs(:home_goals).returns(0)
    game2.stubs(:away_goals).returns(3)

    @stat_tracker.stubs(:games).returns([game1, game2])

    expected = [5,3]
    assert_equal expected, @stat_tracker.games_goal_totals(@stat_tracker.games)
  end

  def test_total_goals
    game = mock('game')
    game.stubs(:home_goals).returns(2)
    game.stubs(:away_goals).returns(3)

    assert_equal 5, @stat_tracker.total_goals(game)
  end

  def test_select_by_key_value
    game_team1 = mock('game_team1')
    game_team2 = mock('game_team2')
    game_team3 = mock('game_team3')
    game_team4 = mock('game_team4')
    game_team1.stubs(:hoa).returns('home')
    game_team1.stubs(:result).returns('WIN')
    game_team2.stubs(:hoa).returns('home')
    game_team2.stubs(:result).returns('LOSS')
    game_team3.stubs(:hoa).returns('away')
    game_team3.stubs(:result).returns('WIN')
    game_team4.stubs(:hoa).returns('away')
    game_team4.stubs(:result).returns('LOSS')
    game_teams = [game_team1, game_team2, game_team3, game_team4]

    assert_equal [game_team1, game_team2], @stat_tracker.select_by_key_value(game_teams, :hoa, "home")
    assert_equal [game_team3, game_team4], @stat_tracker.select_by_key_value(game_teams, :hoa, "away")
    assert_equal [game_team1, game_team3], @stat_tracker.select_by_key_value(game_teams, :result, "WIN")
    assert_equal [game_team2, game_team4], @stat_tracker.select_by_key_value(game_teams, :result, "LOSS")
  end
end
