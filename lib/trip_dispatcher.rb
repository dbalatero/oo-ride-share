require 'csv'
require 'time'
require 'pry'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :passengers, :trips
    attr_accessor :drivers

    def initialize
      @drivers = load_drivers
      @passengers = load_passengers
      @trips = load_trips
    end

    def load_drivers
      my_file = CSV.open('support/drivers.csv', headers: true)
      # my_file = CSV.open('../support/drivers.csv', headers: true)

      all_drivers = []
      my_file.each do |line|
        input_data = {}
        # Set to a default value
        vin = line[2].length == 17 ? line[2] : "0" * 17

        # Status logic
        status = line[3]
        status = status.to_sym

        input_data[:vin] = vin
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:status] = status
        all_drivers << Driver.new(input_data)
      end

      return all_drivers
    end

    def find_driver(id)
      check_id(id)
      @drivers.find{ |driver| driver.id == id }
    end

    def load_passengers
      passengers = []

      CSV.read('support/passengers.csv', headers: true).each do |line|
      # CSV.read('../support/passengers.csv', headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]

        passengers << Passenger.new(input_data)
      end

      return passengers
    end

    def find_passenger(id)
      check_id(id)
      @passengers.find{ |passenger| passenger.id == id }
    end

    def load_trips
      trips = []
      trip_data = CSV.open('support/trips.csv', 'r', headers: true, header_converters: :symbol)
      # trip_data = CSV.open('../support/trips.csv', 'r', headers: true, header_converters: :symbol)

      trip_data.each do |raw_trip|
        driver = find_driver(raw_trip[:driver_id].to_i)
        passenger = find_passenger(raw_trip[:passenger_id].to_i)

        parsed_trip = {
          id: raw_trip[:id].to_i,
          driver: driver,
          passenger: passenger,
          start_time: Time.parse(raw_trip[:start_time]),
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i
        }

        trip = Trip.new(parsed_trip)
        driver.add_trip(trip)
        passenger.add_trip(trip)
        trips << trip
      end
      trips
    end

    def request_trip(passenger_id)
      passenger = verify_passenger(passenger_id)
      driver = next_available_driver

      new_trip = Trip.new(passenger: passenger, id: trips.length + 1, driver: driver, start_time: Time.now)

      passenger.add_trip(new_trip)
      if driver != nil
        driver.unavailable!
        driver.add_trip(new_trip)
      end
      @trips << new_trip
      return new_trip
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def verify_passenger(input_id)
      @passengers.find { |passenger| input_id == passenger.id }
    end

# find all drivers where status is available and they have no in-progress trips
    def next_available_driver
      # binding.pry
      drivers_array = @drivers.find_all { |driver| driver.available? && driver.last_trip_not_nil? }
      driver_with_oldest_trips(drivers_array)
    end

# select driver whose most recent trip ended the longest time ago
    def driver_with_oldest_trips(available_drivers)
      driver_with_oldest_trip = nil
      oldest_trip_time = Time.now
      available_drivers.each do |driver|
        if driver.trips.empty?
          return driver
        elsif driver.trips.last.end_time < oldest_trip_time
          oldest_trip_time = driver.trips.last.end_time
          driver_with_oldest_trip = driver
        end
      end
      return driver_with_oldest_trip
    end

    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end

dispatcher = RideShare::TripDispatcher.new
dispatcher.request_trip(18)
