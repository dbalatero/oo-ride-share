require_relative 'spec_helper'
require 'awesome_print'
require 'pry'

describe "TripDispatcher class" do
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = RideShare::TripDispatcher.new
      dispatcher.must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      dispatcher = RideShare::TripDispatcher.new
      [:trips, :passengers, :drivers].each do |prop|
        dispatcher.must_respond_to prop
      end

      dispatcher.trips.must_be_kind_of Array
      dispatcher.passengers.must_be_kind_of Array
      dispatcher.drivers.must_be_kind_of Array
    end
  end

  describe "find_driver method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      driver.must_be_kind_of RideShare::Driver
    end
  end

  describe "find_passenger method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
    end

    it "throws an argument error for a bad ID" do
      proc{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a passenger instance" do
      passenger = @dispatcher.find_passenger(2)
      passenger.must_be_kind_of RideShare::Passenger
    end
  end

  describe "loader methods" do
    it "accurately loads driver information into drivers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_driver = dispatcher.drivers.first
      last_driver = dispatcher.drivers.last

      first_driver.name.must_equal "Bernardo Prosacco"
      first_driver.id.must_equal 1
      first_driver.status.must_equal :UNAVAILABLE
      last_driver.name.must_equal "Minnie Dach"
      last_driver.id.must_equal 100
      last_driver.status.must_equal :AVAILABLE
    end

    it "accurately loads passenger information into passengers array" do
      dispatcher = RideShare::TripDispatcher.new

      first_passenger = dispatcher.passengers.first
      last_passenger = dispatcher.passengers.last

      first_passenger.name.must_equal "Nina Hintz Sr."
      first_passenger.id.must_equal 1
      last_passenger.name.must_equal "Miss Isom Gleason"
      last_passenger.id.must_equal 300
    end

    it "accurately loads trip info and associates trips with drivers and passengers" do
      dispatcher = RideShare::TripDispatcher.new

      trip = dispatcher.trips.first
      driver = trip.driver
      passenger = trip.passenger

      driver.must_be_instance_of RideShare::Driver
      driver.trips.must_include trip
      passenger.must_be_instance_of RideShare::Passenger
      passenger.trips.must_include trip
      trip.start_time.must_be_instance_of Time
      trip.end_time.must_be_instance_of Time

    end
  end

  describe "request_trip(passenger_id) method" do

    # I think this let statement is legal in Minitest?
    let(:dispatcher) { RideShare::TripDispatcher.new }

    it "creates a new instance of Trip" do
      trip = dispatcher.request_trip(10)
      trip.must_be_instance_of RideShare::Trip
      trip.id.must_equal 601
      trip.passenger.id.must_equal 10
    end

    it "selects the first available driver" do
      trip = dispatcher.request_trip(10)

      trip.driver.id.must_equal 100
      trip.driver.name.must_equal "Minnie Dach"
    end

    it "changes driver status to UNAVAILABLE" do
      trip = dispatcher.request_trip(5)
      trip.driver.status.must_equal :UNAVAILABLE
    end

    it "return nil if no drivers are available" do
      dispatcher.drivers = []
      trip = dispatcher.request_trip(5)
      trip.driver.must_be_nil
    end

    it "stores the current time as the start_time" do
      trip = dispatcher.request_trip(5)
      trip.start_time.must_be_instance_of Time
    end

    it "sets the defaults for end_time, cost, and rating to nil" do
      trip = dispatcher.request_trip(20)

      trip.end_time.must_be_nil
      trip.cost.must_be_nil
      trip.rating.must_be_nil
    end

    it "stores new instance of Trip in corresponding passenger's collection of Trips" do
      trip = dispatcher.request_trip(7)
      trip.passenger.trips.length.must_equal 4
      trip.passenger.trips.must_include trip
    end

    it "stores new instance of Trip in corresponding driver's collection of Trips" do
      trip = dispatcher.request_trip(7)
      trip.driver.trips.must_include trip
    end

    it "stores new instance of Trip in TripDispatcher's collection of Trips" do
      trip = dispatcher.request_trip(7)
      dispatcher.trips.must_include trip
    end

  end
end
