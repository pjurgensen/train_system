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

end
