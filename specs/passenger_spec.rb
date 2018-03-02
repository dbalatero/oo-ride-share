require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-08-21T08:51:00+00:00", end_time: "2016-08-21T09:29:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: "2015-09-13T22:47:00+00:00", end_time: "2015-09-13T23:17:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end

  describe "total_spent method" do

    before do
      @passenger_1 = RideShare::Passenger.new(id: 54, name: "Gracie Emmerich", phone: "591-707-1595 x0908", trips: [])

      trip_1 = RideShare::Trip.new({id: 1, driver: 1, passenger: @passenger_1, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", cost: "17.39", rating: 3})
      trip_2 = RideShare::Trip.new({id: 342, driver: 39, passenger: @passenger_1, start_time: "2016-02-29T04:02:00+00:00", end_time: "2016-02-29T04:50:00+00:00", cost: "26.58", rating: 2})

      @passenger_1.add_trip(trip_1)
      @passenger_1.add_trip(trip_2)
    end

    it "returns the total amount of money that a passenger has spent on all of their trips" do
      @passenger_1.total_spent.must_equal 43.97
      @passenger_1.total_spent.must_be_kind_of Float
      @passenger_1.trips.length.must_equal 2
    end
  end

  describe "total_time method" do

    before do
      @passenger_2 = RideShare::Passenger.new(id: 54, name: "Gracie Emmerich", phone: "591-707-1595 x0908", trips: [])

      trip_1 = RideShare::Trip.new({id: 1, driver: 1, passenger: @passenger_2, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", cost: "17.39", rating: 3})
      trip_2 = RideShare::Trip.new({id: 342, driver: 39, passenger: @passenger_2, start_time: "2016-02-29T04:02:00+00:00", end_time: "2016-02-29T04:50:00+00:00", cost: "26.58", rating: 2})

      @passenger_2.add_trip(trip_1)
      @passenger_2.add_trip(trip_2)
    end

    it "returns the total amount of time that a passenger has spent on all of their trips" do
      @passenger_2.total_time.must_equal 3360.0
      @passenger_2.total_time.must_be_kind_of Float
    end
  end
end
