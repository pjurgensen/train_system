require './lib/station.rb'
require './lib/line.rb'
require 'pg'

DB = PG.connect({:dbname => 'train_system'})

def main_menu
  system("clear")
  puts "Please enter 'o' if you are an operator"
  puts "Please enter 'r' if you are a rider"
  puts "Please enter 'x' to exit"
  user_input = gets.chomp.downcase

  case user_input
    when 'o' then operator_menu
    when 'r' then rider_menu
    when 'x' then puts "Goodbye"
    else puts "Please enter a valid option"
    sleep(1)
    main_menu
  end
end

def operator_menu
  system("clear")
  puts "Please enter 's' to add a new station"
  puts "Please enter 'l' to add a new line"
  puts "Please enter 'm' to return to the main menu"
  puts "Please enter 'x' to exit"
  user_input = gets.chomp.downcase

  case user_input
    when 's' then add_station
    when 'l' then add_line
    when 'm' then main_menu
    when 'x' then puts "See ya sucka"
    else puts "Please enter a valid option"
    sleep(1)
    operator_menu
  end
end

def rider_menu
  system("clear")
  puts "Please enter 's' to list all of the stations"
  puts "Please enter 'sl' to list stations by lines"
  puts "Please enter 'l' to list all of the lines"
  puts "Please enter 'ls' to list lines by stations"
  puts "Please enter 'm' to return to the main menu"
  puts "Please enter 'x' to exit"
  user_input = gets.chomp.downcase

  case user_input
    when 's' then list_stations
      return_to_rider_menu
    when 'sl' then list_stations_by_line_menu
      return_to_rider_menu
    when 'l' then list_lines
      return_to_rider_menu
    when 'ls' then list_lines_by_station_menu
      return_to_rider_menu
    when 'm' then main_menu
    when 'x' then puts "Bye"
    else puts "Please enter a valid option"
    sleep(1)
    rider_menu
  end
end

def add_station
  system("clear")
  puts "Please enter the location of the new station"
  station_location = gets.chomp

  new_station = Station.create({'location' => station_location})
  add_line_to_station(new_station)

  puts "\n#{station_location} has been added with:"
  list_lines_by_station(new_station.id)

  puts "Would you like to add another station? Press 'y' for yes or 'n' for no"
  user_input = gets.chomp.downcase

  case user_input
    when 'y' then add_station
    when 'n' then operator_menu
    else puts "Please enter a valid option"
    sleep(1)
    add_station
  end
end

def add_line_to_station(new_station)
  list_lines
  puts "Please select a train line by ID that serves #{new_station.location}"
  id_choice = gets.chomp
  begin
    new_station.create_stop(id_choice)
  rescue
    puts "Invalid ID, try again"
    sleep(1)
    add_line_to_station
  end
  puts "The number #{id_choice} line has been added to #{new_station.location}."
  puts "Would you like to add another train line? Press 'y' for yes or 'n' for no"
  user_input = gets.chomp.downcase

  case user_input
    when 'y' then add_line_to_station(new_station)
    when 'n' then
    else puts "Please enter a valid option"
    sleep(1)
    add_line_to_station(new_station)
  end
end

def add_line
  system("clear")
  puts "Please enter the name of the new line"
  line_name = gets.chomp
  new_line = Line.create({'name' => line_name})
  puts "\n#{line_name} has been added to the following stations:"
  list_stations_by_line(new_line.id)
  puts "Would you like to add another line? Press 'y' for yes or 'n' for no"
  user_input = gets.chomp.downcase

  case user_input
    when 'y' then add_line
    when 'n' then operator_menu
    else puts "Please enter a valid option"
    sleep(1)
    add_line
  end
end

def list_stations
  system("clear")
  puts "Here is a list of all the stations:"
  Station.all.each do |station|
    puts "#{station.id}. #{station.location}"
  end
end

def list_stations_by_line_menu
  system("clear")
  list_lines
  puts "Please enter the line ID you would like a list of stations for:"
  line_id = gets.chomp
  list_stations_by_line(line_id)
end

def list_stations_by_line(line_id)
  begin
    stations_served = Line.stations_served_by_line(line_id)
  rescue
    puts "Invalid ID, try again"
    sleep(1)
    list_stations_by_line_menu
  end
  stations_served.each do |station|
    puts "Station ##{station}" #ADD STATION NAME SOMEHOW - WITH A 'FIND_BY_ID' METHOD
  end
  puts "\n\n"
end

def list_lines
  system("clear")
  puts "Here is a list of all the lines:"
  Line.all.each do |line|
    puts "#{line.id}. #{line.name}"
  end
end

def list_lines_by_station_menu
  system("clear")
  list_stations
  puts "Please enter the station ID you would like a list of lines for:"
  station_id = gets.chomp
  list_lines_by_station(station_id)
end

def list_lines_by_station(station_id)
  begin
    available_lines = Station.lines_serving_station(station_id)
  rescue
    puts "Invalid ID, try again"
    sleep(1)
    list_lines_by_station_menu
  end
  available_lines.each do |line|
    puts "Line ##{line}" #ADD LINE NAME SOMEHOW - WITH A 'FIND_BY_ID' METHOD
  end
  puts "\n\n"
end

def return_to_rider_menu
  puts "Press 'm' to return to the rider menu or 'x' to exit\n\n"
  user_input = gets.chomp.downcase

  case user_input
    when 'm' then rider_menu
    when 'x' then puts "Goodbye"
    else puts "Please enter a valid option"
    sleep(1)
    list_lines
  end
end

main_menu
