class Line
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id'].to_i
  end

  def save
    result = DB.exec("INSERT INTO lines (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def self.stations_served_by_line(line_id)
    station_objects = DB.exec("SELECT * FROM stops WHERE line_id = #{line_id};")
    stops_served = []
    station_ids_array = []
    station_objects.each do |object|
      station_ids_array << object['station_id'].to_i
      results = DB.exec("SELECT * FROM stations WHERE id IN('#{station_ids_array.join(',')}');")
      results.each do |result|
        stops_served << Station.create(result)
      end
    end
    stops_served
  end

  def self.create(attributes)
    new_line = Line.new(attributes)
    new_line.save
    new_line
  end

  def self.all
    results = DB.exec("SELECT * FROM lines;")
    lines = []
    results.each do |result|
      new_line = Line.new(result)
      lines << new_line
    end
    lines
  end

  def ==(another_line)
    self.name == another_line.name && self.id == another_line.id
  end

  def self.update(line_id, new_name)
    DB.exec("UPDATE lines SET name = '#{new_name}' WHERE id = #{line_id};")
  end

  def self.delete(line_id)
    DB.exec("DELETE FROM lines WHERE id = #{line_id};")
  end
end
