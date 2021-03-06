require './test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/team'

class TeamTest < Minitest::Test

  def setup
    @atlanta = Team.new({
      team_id: "1",
      franchiseid: "23",
      teamname: "Atlanta United",
      abbreviation: "ATL",
      link: "/api/v1/teams/1"
    })
  end

  def test_it_exists

    assert_instance_of Team, @atlanta
  end

  def test_it_has_attributes

    assert_equal "1", @atlanta.team_id
    assert_equal "23", @atlanta.franchiseid
    assert_equal "Atlanta United", @atlanta.teamname
    assert_equal "ATL", @atlanta.abbreviation
    assert_equal "/api/v1/teams/1", @atlanta.link
  end

end
