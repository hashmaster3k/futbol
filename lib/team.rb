require 'csv'

class Team

  attr_reader :team_id,
              :franchiseid,
              :teamname,
              :abbreviation,
              :link
  def initialize(args)
    @team_id      = args[:team_id]
    @franchiseid  = args[:franchiseid]
    @teamname     = args[:teamname]
    @abbreviation = args[:abbreviation]
    @link         = args[:link]
  end

  def self.create_teams(path)
    return [] if !File.exist?(path)
    teams = []
    CSV.foreach(path, headers: true, header_converters: :symbol) do |team_data|
      teams << new(team_data)
    end
    teams
  end
end
