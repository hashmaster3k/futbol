require 'csv'

class Stat
  def self.create_instances(path)
    return [] if !File.exist?(path)
    instances = []
    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      instances << new(data)
    end
    instances
  end
end
