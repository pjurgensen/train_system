class Station
  attr_reader :location, :id, :line_ids

  def initialize(attributes)
    @location = attributes['location']
    @id = attributes['id'].to_i
    @line_ids = []
  end

  def save
    result = DB.exec("INSERT INTO stations (location) VALUES ('#{@location}')RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another_station)
    self.location == another_station.location && self.id == another_station.id
  end

  def create_stop(line_id)
    DB.exec("INSERT INTO stops (station_id, line_id) VALUES (#{self.id}, #{line_id})")
    @line_ids << line_id
  end

  def lines_serving_station
    DB.exec("SELECT * FROM lines JOIN stops ON stops.line_id = lines.id JOIN stations ON stations.id = stops.station_id WHERE stations.id = #{self.id};")
  end

  def self.create(attributes)
    new_location = Station.new(attributes)
    new_location.save
    new_location
  end

  def self.all
    results = DB.exec("SELECT * FROM stations;")
    stations = []
    results.each do |result|
      stations << Station.new(result)
    end
    stations
  end

end

