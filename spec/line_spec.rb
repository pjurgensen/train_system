require 'spec_helper'

describe Line do
  it 'initializes a line instance with a name' do
    test_line = Line.new({'name' => 'blue'})
    test_line.should be_an_instance_of Line
  end

  it 'gives the line a name' do
    test_line = Line.new({'name' => 'blue', 'id' => 2})
    test_line.name.should eq 'blue'
    test_line.id.should be_an_instance_of Fixnum
  end

  describe '.create' do
    it 'creates and saves a new line' do
      test_line = Line.create({'name' => 'blue', 'id' => 2})
      Line.all.should eq [test_line]
    end
  end

  describe '.all' do
    it 'starts empty' do
      Line.all.should eq []
    end
  end

  describe '#save' do
    it 'saves a new line' do
      test_line = Line.new({'name' => 'blue', 'id' => 2})
      test_line.save
      Line.all.should eq [test_line]
    end
  end

  describe '#==' do
    it 'recognizes two lines with the same name and id are the same line' do
      test_line1 = Line.new({'name' => 'blue', 'id' => 2})
      test_line2 = Line.new({'name' => 'blue', 'id' => 2})
      test_line1.should eq test_line2
    end
  end

  describe '.stations_served_by_line' do
    it 'shows the stations for a line' do
      test_station = Station.create({'location' => 'Rose Quarter', 'id' => 2})
      test_line = Line.create({'name' => 'blue', 'id' => 1})
      test_station.create_stop(test_line.id)
      Line.stations_served_by_line(test_line.id)[0].should be_an_instance_of Fixnum
    end
  end

  describe '#create_stop' do
    it 'assigns stations to a line' do
      test_station = Station.new({'location' => 'Rose Quarter', 'id' => 2})
      test_station.create_stop(1)
      result = DB.exec("SELECT * FROM stops WHERE station_id = #{test_station.id};")
      result[0]['line_id'].to_i.should eq 1
    end
  end

  describe '#update' do
    it 'updates the name of a line' do
      test_line = Line.create({'name' => 'blue', 'id' => 1})
      test_line.update("Red")
      result = DB.exec("SELECT * FROM lines WHERE id = #{test_line.id}")
      result[0]['name'].should eq "Red"
    end
  end

end
