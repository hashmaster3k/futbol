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
    game1 = mock(home_goals: 4, away_goals: 6)
    game2 = mock(home_goals: 2, away_goals: 2)
    game3 = mock(home_goals: 0, away_goals: 3)

    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 10, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    game1 = mock(home_goals: 4, away_goals: 6)
    game2 = mock(home_goals: 2, away_goals: 2)
    game3 = mock(home_goals: 0, away_goals: 3)
    @stat_tracker.stubs(:games).returns([
      game1,
      game2,
      game3
    ])

    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_percentage_home_wins
    game_team1 = mock(hoa: 'home', result: 'LOSS')
    game_team2 = mock(hoa: 'home', result: 'WIN')
    game_team3 = mock(hoa: 'home', result: 'WIN')
    game_team4 = mock(hoa: 'away', result: 'WIN')

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
    game_team1 = mock(hoa: 'away', result: 'LOSS')
    game_team2 = mock(hoa: 'away', result: 'WIN')
    game_team3 = mock(hoa: 'away', result: 'WIN')
    game_team4 = mock(hoa: 'home', result: 'WIN')

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
    game_team1 = mock(hoa: 'away', result: 'TIE')
    game_team2 = mock(hoa: 'away', result: 'TIE')
    game_team3 = mock(hoa: 'away', result: 'LOSS')
    game_team4 = mock(hoa: 'home', result: 'WIN')

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
    game1 = mock(season: 20122013)
    game2 = mock(season: 20122013)
    game3 = mock(season: 20122013)
    game4 = mock(season: 20132014)
    game5 = mock(season: 20132014)
    game6 = mock(season: 20142015)
    games = [game1, game2, game3, game4, game5, game6]
    @stat_tracker.stubs(:games).returns(games)

    expected = {"20122013" => 3, "20132014" => 2, "20142015" => 1}
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    game1 = mock(season: 20122013, home_goals: 3, away_goals: 2)
    game2 = mock(season: 20122013, home_goals: 2, away_goals: 1)
    game3 = mock(season: 20122013, home_goals: 4, away_goals: 0)
    game4 = mock(season: 20132014, home_goals: 1, away_goals: 1)
    game5 = mock(season: 20132014, home_goals: 1, away_goals: 2)
    game6 = mock(season: 20142015, home_goals: 0, away_goals: 3)
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
    game1 = mock(season: 20122013, home_goals: 3, away_goals: 2)
    game2 = mock(season: 20122013, home_goals: 2, away_goals: 1)
    game3 = mock(season: 20122013, home_goals: 4, away_goals: 0)
    game4 = mock(season: 20132014, home_goals: 1, away_goals: 1)
    game5 = mock(season: 20132014, home_goals: 1, away_goals: 2)
    game6 = mock(season: 20142015, home_goals: 0, away_goals: 1)
    game7 = mock(season: 20142015, home_goals: 0, away_goals: 1)
    game8 = mock(season: 20142015, home_goals: 0, away_goals: 0)
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
    game1 = mock(season: 20122013, home_goals: 3, away_goals: 2)
    game2 = mock(season: 20122013, home_goals: 2, away_goals: 1)
    game3 = mock(season: 20122013, home_goals: 4, away_goals: 0)
    game4 = mock(season: 20132014, home_goals: 1, away_goals: 1)
    game5 = mock(season: 20132014, home_goals: 1, away_goals: 2)
    game6 = mock(season: 20142015, home_goals: 0, away_goals: 3)

    games = [game1, game2, game3, game4, game5, game6]

    @stat_tracker.stubs(:games).returns(games)

    expected = ["20122013", "20132014", "20142015"]
    assert_equal expected, @stat_tracker.all_seasons
  end

  def test_games_goal_totals
    game1 = mock(home_goals: 2, away_goals: 3)
    game2 = mock(home_goals: 0, away_goals: 3)

    @stat_tracker.stubs(:games).returns([game1, game2])

    expected = [5,3]
    assert_equal expected, @stat_tracker.games_goal_totals(@stat_tracker.games)
  end

  def test_total_goals
    game = mock(home_goals: 2, away_goals: 3)

    assert_equal 5, @stat_tracker.total_goals(game)
  end

  def test_select_by_key_value
    game_team1 = mock(hoa: 'home', result: 'WIN')
    game_team2 = mock(hoa: 'home', result: 'LOSS')
    game_team3 = mock(hoa: 'away', result: 'WIN')
    game_team4 = mock(hoa: 'away', result: 'LOSS')
    game_teams = [game_team1, game_team2, game_team3, game_team4]

    assert_equal [game_team1, game_team2], @stat_tracker.select_by_key_value(game_teams, :hoa, "home")
    assert_equal [game_team3, game_team4], @stat_tracker.select_by_key_value(game_teams, :hoa, "away")
    assert_equal [game_team1, game_team3], @stat_tracker.select_by_key_value(game_teams, :result, "WIN")
    assert_equal [game_team2, game_team4], @stat_tracker.select_by_key_value(game_teams, :result, "LOSS")
  end
end
