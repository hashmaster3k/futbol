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

end
