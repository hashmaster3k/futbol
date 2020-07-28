require './test/test_helper'
require './lib/season_statistics'
require './lib/stat_tracker'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class StatTrackerTest < Minitest::Test

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

  def test_winningest_coach_with_mock
    locations = {
      games: 'no path',
      teams: 'no path',
      game_teams: 'no path'
    }

    stat_tracker = StatTracker.from_csv(locations)

    game_team_1 = mock(game_id: 2012001, head_coach: "Tom", result: "WIN")
    game_team_2 = mock(game_id: 2012002, head_coach: "Tom", result: "LOSS")
    game_team_3 = mock(game_id: 2012003, head_coach: "Bill", result: "WIN")
    game_team_4 = mock(game_id: 2012004, head_coach: "Bill", result: "WIN")
    game_team_5 = mock(game_id: 2012005, head_coach: "Nick", result: "WIN")
    game_team_6 = mock(game_id: 2012006, head_coach: "Nick", result: "LOSS")


    stat_tracker.stubs(:game_teams).returns([game_team_1,
                                             game_team_2,
                                             game_team_3,
                                             game_team_4,
                                             game_team_5,
                                             game_team_6])

    assert_equal "Bill", stat_tracker.winningest_coach("20122013")
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20132014")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_worst_coach
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
    assert_equal "Ted Nolan", @stat_tracker.worst_coach("20142015")
  end

  def test_most_accurate
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team("20132014")
    assert_equal "Toronto FC", @stat_tracker.most_accurate_team("20142015")
  end

  def test_least_accurate
    assert_equal "New York City FC", @stat_tracker.least_accurate_team("20132014")
    assert_equal "Columbus Crew SC", @stat_tracker.least_accurate_team("20142015")
  end

  def test_most_tackles
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles("20132014")
    assert_equal "Seattle Sounders FC", @stat_tracker.most_tackles("20142015")
  end

  def test_fewest_tackles
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles("20132014")
    assert_equal "Orlando City SC", @stat_tracker.fewest_tackles("20142015")
  end

end
