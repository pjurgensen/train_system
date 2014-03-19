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
  puts "Please enter 'l' to list all of the lines"
  puts "Please enter 'm' to return to the main menu"
  puts "Please enter 'x' to exit"
  user_input = gets.chomp.downcase

  case user_input
    when 's' then list_stations
      return_to_rider_menu
    when 'l' then list_lines
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
  puts "Please select a train line by ID that serves #{station_location}"
  list_lines
  id_choice = gets.chomp
  new_station = Station.create({'location' => station_location})
  new_station.create_stop(id_choice)

  puts "\n#{station_location} has been added\n\n"
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

def add_line
  system("clear")
  puts "Please enter the name of the new line"
  line_name = gets.chomp
  Line.create({'name' => line_name})
  puts "\n#{line_name} has been added\n\n"
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

def list_lines
  system("clear")
  puts "Here is a list of all the lines:"
  Line.all.each do |line|
    puts "#{line.id}. #{line.name}"
  end
end

def return_to_rider_menu
  puts "\nPress 'm' to return to the rider menu or 'x' to exit\n\n"
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
