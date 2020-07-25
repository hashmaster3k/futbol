require 'minitest/autorun'
require 'minitest/pride'
require './lib/games_collection'
require './lib/game'
require 'csv'

class GamesCollectionTest < Minitest::Test
  def setup
    @gc = GamesCollection.new('./test/fixtures/games.csv')
  end

  def test_it_exists
    assert_instance_of GamesCollection, @gc
  end

  def test_has_a_path
    assert_equal './test/fixtures/games.csv', @gc.path
  end

  def test_it_can_read
    assert_equal 240, @gc.all_games.length
    assert_equal Game, @gc.all_games[0].class
  end

  def test_add_game_teams
    @gc.add_game({})
    assert_equal 241, @gc.all_games.length
  end
end
