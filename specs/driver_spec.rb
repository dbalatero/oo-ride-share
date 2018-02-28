require_relative 'spec_helper'
require 'pry'

describe "Driver class" do

  before do
    @driver_1 = RideShare::Driver.new(id: 3, name: "Daryl Nitzsche", vin: "SAL6P2M2XNHC5Y656", status: "AVAILABLE")

    trip_1 = RideShare::Trip.new({id: 430, driver: @driver_1, passenger: 15, start_time: "2016-02-10T21:07:00+00:00", end_time: "2016-02-10T21:21:00+00:00", cost: "23.88", rating: 5})
    trip_2 = RideShare::Trip.new({id: 593, driver: @driver_1, passenger: 158, start_time: "2015-10-08T15:01:00+00:00", end_time: "2015-10-08T15:44:00+00:00", cost: "26.91", rating: 5})
    trip_3 = RideShare::Trip.new({id: 312, driver: @driver_1, passenger: 279, start_time: "2015-10-07T01:03:00+00:00", end_time: "2015-10-07T01:40:00+00:00", cost: "14.52", rating: 1})

    @driver_1.add_trip(trip_1)
    @driver_1.add_trip(trip_2)
    @driver_1.add_trip(trip_3)
  end

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status].each do |prop|
        @driver.must_respond_to prop
      end

      @driver.id.must_be_kind_of Integer
      @driver.name.must_be_kind_of String
      @driver.vehicle_id.must_be_kind_of String
      @driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, date: "2016-08-08", rating: 5})
      @driver.add_trip(trip)
    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end

  end

  describe "get_total_revenue method" do

    it "gets total revenue for a driver" do
      total_rev = @driver_1.get_total_revenue

      total_rev.must_equal 48.29
    end

  describe "total_hours_driving method" do

    it "gets total time driver spent driving across all trips" do
      total_time = @driver_1.total_hours_driving

      total_time.must_equal 1.57
      # in seconds, total is 5640.0

    end

  end

  describe "avg_revenue_per_hour method" do

    it "gets average revenue per hour for a drivers' trips" do
      avg_per_hour = @driver_1.avg_revenue_per_hour

      avg_per_hour.must_equal 30.76
    end

  end

  end
end
