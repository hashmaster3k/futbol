require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
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

  def test_it_can_return_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_it_can_return_unique_teams
    assert_equal 32, @stat_tracker.unique_teams.count
  end

  def test_it_can_return_games_by_team_id_mock
    locations = {
      games: "no path",
      teams: "no path",
      game_teams: "no path"
    }

    game_1 = mock('game_1')
    game_2 = mock('game_2')
    game_3 = mock('game_3')
    game_1.stubs(:team_id).returns(19)
    game_2.stubs(:team_id).returns(19)
    game_3.stubs(:team_id).returns(19)

    stat_tracker = StatTracker.from_csv(locations)

    stat_tracker.stubs(:game_teams).returns([game_1, game_2, game_3])
    assert_equal 3, stat_tracker.games_by_team_id(19).count
  end

  # def test_it_can_return_games_by_team_id
  #   assert_equal 5, @stat_tracker.games_by_team_id(19).count
  # end

  def test_it_can_return_count_of_goals_by_team_id
    assert_equal 9, @stat_tracker.count_of_goals_by_team_id(19)
  end

  def test_it_can_return_teams_average_goals_per_season
    assert_equal 1.8, @stat_tracker.average_goals_per_season(19)
  end

  def test_it_can_return_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end

  def test_it_can_return_worst_offense
    assert_equal "Houston Dynamo", @stat_tracker.worst_offense
  end

  def test_it_can_return_away_games_by_team_id
    assert_equal 4, @stat_tracker.away_games_by_team_id(19).count
  end

  def test_it_can_return_count_of_away_goals_by_team_id
    assert_equal 6, @stat_tracker.away_count_of_goals_by_team_id(19)
  end

  def test_it_can_return_teams_average_goals_per_game_when_away
    assert_equal 1.5, @stat_tracker.average_goals_per_game_when_away(19)
  end

  def test_it_can_return_highest_scoring_visitor
    assert_equal "Sporting Kansas City", @stat_tracker.highest_scoring_visitor
  end

  def test_it_can_return_home_games_by_team_id
    assert_equal 1, @stat_tracker.home_games_by_team_id(19).count
  end

  def test_it_can_return_count_of_home_goals_by_team_id
    assert_equal 3, @stat_tracker.home_count_of_goals_by_team_id(19)
  end

  def test_it_can_return_teams_average_goals_per_game_when_home
    assert_equal 3.0, @stat_tracker.average_goals_per_game_when_home(19)
  end

  def test_it_can_return_highest_scoring_home_team
    assert_equal "Reign FC", @stat_tracker.highest_scoring_home_team
  end

  def test_it_can_return_lowest_scoring_visitor
    assert_equal "Chicago Red Stars", @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_return_lowest_scoring_home_team
    assert_equal "Houston Dynamo", @stat_tracker.lowest_scoring_home_team
  end
end
