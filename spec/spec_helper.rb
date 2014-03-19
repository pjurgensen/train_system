require 'rspec'
require 'station'
require 'line'
require 'pg'

DB = PG.connect({:dbname => 'train_system_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM stations *;")
    DB.exec("DELETE FROM lines *;")
    DB.exec("DELETE FROM stops *;")
  end
end
