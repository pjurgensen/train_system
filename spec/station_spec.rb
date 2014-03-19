require 'spec_helper'

describe Station do
  it 'initializes an instance of Station with a location name' do
    test_station = Station.new({'location' => 'Rose Quarter'})
    test_station.should be_an_instance_of Station
  end

  it 'gives us the location and id' do
    test_station = Station.new({'location' => 'Rose Quarter', 'id' => 2})
    test_station.location.should eq 'Rose Quarter'
    test_station.id.should be_an_instance_of Fixnum
  end

  describe '.create' do
    it 'creates and saves a location' do
      test_station = Station.create({'location' => 'Rose Quarter', 'id' => 2})
      Station.all.should eq [test_station]
    end
  end

  describe '.all' do
    it 'starts empty' do
      Station.all.should eq []
    end
  end

  describe '#save' do
    it 'saves the station into the database' do
      test_station = Station.new({'location' => 'Rose Quarter', 'id' => 2})
      test_station.save
      Station.all.should eq [test_station]
    end
  end

  describe '#==' do
    it 'recognizes that two locations are equal if their location and id are the same' do
      test_station1 = Station.new({'location' => 'Rose Quarter', 'id' => 2})
      test_station2 = Station.new({'location' => 'Rose Quarter', 'id' => 2})
      test_station1.should eq test_station2
    end
  end

  # describe '#lines_serving_station' do
  #   it 'shows the lines for a station' do
  #     test_station = Station.create({'location' => 'Rose Quarter', 'id' => 2})
  #     test_station
  #   end
  # end

  describe '#create_stop' do
    it 'assigns lines to a station' do
      test_station = Station.new({'location' => 'Rose Quarter', 'id' => 2})
      test_station.create_stop(1)
      test_station.line_ids.should eq [1]
      result = DB.exec("SELECT * FROM stops WHERE station_id = #{test_station.id};")
      result[0]['line_id'].to_i.should eq 1
    end
  end


end
