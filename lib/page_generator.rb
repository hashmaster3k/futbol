require 'erb'

class PageGenerator
  attr_reader :template, :binding_klass

  def initialize(binding_klass)
    @template = File.open('./templates/index.erb', 'rb', &:read)
    @binding_klass = binding_klass
  end

  def render
    ERB.new(template).result(binding_klass.get_binding)
  end
end


require './lib/stat_tracker'

game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

File.write('./site/index.html', stat_tracker.build.render)
