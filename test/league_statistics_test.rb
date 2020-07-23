require 'minitest/autorun'
require 'minitest/pride'
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

  # def test_highest_total_score
  #   assert_equal 8, @stat_tracker.highest_total_score
  # end

  def test_it_can_return_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_it_can_return_count_of_games_by_team_id
    assert_equal 5, @stat_tracker.count_of_games_by_team_id(19)
  end

  # def test_it_can_return_best_offense
  #   assert_equal "Reign FC", @stat_tracker.best_offense
  # end

end
