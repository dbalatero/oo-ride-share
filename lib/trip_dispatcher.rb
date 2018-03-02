require 'csv'
require 'time'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize
      @drivers = load_drivers
      @passengers = load_passengers
      @trips = load_trips
    end

    def load_drivers
      my_file = CSV.open('support/drivers.csv', headers: true)

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
<<<<<<< HEAD
      driver = next_available_driver
      driver.unavailable!

      Trip.new(driver: driver)
    end

=======
    #   #add something to check that passenger id already exists!
    #   check_id(passenger_id)
    #   passenger = passenger_id
    #   # use .max_by
    #   new_driver = nil
    #   # until @driver.status == :AVAILABLE do
    #   @drivers.each do |driver|
    #     if driver.status == :AVAILABLE
    #       new_driver = driver.id
    #       # driver.status = :UNAVAILABLE
    #     else
    #       new_driver = nil
    #     end
    #   end
    #   new_start_time = Time.now
    #   new_trip_info = {
    #     id: nil,
    #     driver: new_driver,
    #     passenger: passenger,
    #     start_time: new_start_time,
    #     end_time: nil,
    #     cost: nil,
    #     rating: nil
    #   }
    #   new_trip = RideShare::Trip.new(new_trip_info)
    #   return new_trip
    # end


>>>>>>> request_trip method and tests in progress
    # In Ruby, by default, all methods are 'public'. We can circumvent this by creating a private method, so that no other classes or objects can call it. Any methods listed under the 'private' keyword will be private. Often simple helper methods go here. NOTE: In Ruby, in general, order of method definitions does not matter (except for 'private') but in other languages, order does matter.
    private

    def next_available_driver
      @drivers.find { |driver| driver.available? }
    end


    def check_id(id)
      if id == nil || id <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{id})")
      end
    end
  end
end
