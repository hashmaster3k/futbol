require 'csv'

class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link

  def initialize(args)
    @game_id      = args[:game_id].to_i
    @season       = args[:season].to_i
    @type         = args[:type]
    @date_time    = args[:date_time]
    @away_team_id = args[:away_team_id].to_i
    @home_team_id = args[:home_team_id].to_i
    @away_goals   = args[:away_goals].to_i
    @home_goals   = args[:home_goals].to_i
    @venue        = args[:venue]
    @venue_link   = args[:venue_link]
  end

  def self.create_games(path)
    return [] if !File.exist?(path)
    games = []
    CSV.foreach(path, headers: true, header_converters: :symbol) do |game_data|
      games << new(game_data)
    end
    games
  end
end
