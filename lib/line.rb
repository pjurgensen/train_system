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
end
