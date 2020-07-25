require './lib/team_statistics'
require './lib/stat_tracker'
require 'minitest/autorun'
require 'minitest/pride'

class TeamStatisticsTest < Minitest::Test

  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {games: game_path,
                 teams: team_path,
                 game_teams: game_teams_path}

    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_stores_information
    expected = {"team_id"      => "18",
                "franchise_id" => "34",
                "team_name"    => "Minnesota United FC",
                "abbreviation" => "MIN",
                "link"         => "/api/v1/teams/18"}

    assert_equal expected, @stat_tracker.team_info("18")
  end

  def test_best_season
    assert_equal "20132014", @stat_tracker.best_season("6")
  end

  def test_worst_season
    assert_equal "20142015", @stat_tracker.worst_season("6")
  end

  def test_average_win_percentage
    assert_equal 0.49, @stat_tracker.average_win_percentage("6")
  end

  def test_it_can_return_most_goals_scored_in_single_game
    assert_equal 7, @stat_tracker.most_goals_scored("18")
  end

  def test_it_can_return_fewest_goals_scored_in_single_game
    assert_equal 0, @stat_tracker.fewest_goals_scored("18")
  end

  def test_it_can_return_name_of_favorite_opponent
    skip
    assert_equal "DC United", @stat_tracker.favorite_opponent("18")
  end

  def test_it_can_return_name_of_rival
    assert_equal "LA Galaxy", @stat_tracker.rival("18")
  end

end
