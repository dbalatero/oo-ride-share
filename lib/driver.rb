require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status
    attr_accessor :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero. (got #{input[:id]})")
      end
      if input[:vin] == nil || input[:vin].length != 17
        raise ArgumentError.new("VIN cannot be less than 17 characters.  (got #{input[:vin]})")
      end

      @id = input[:id]
      @name = input[:name]
      @vehicle_id = input[:vin]
      @status = input[:status] == nil ? :AVAILABLE : input[:status]

      @trips = input[:trips] == nil ? [] : input[:trips]
    end

    def average_rating
      total_ratings = 0
      @trips.each do |trip|
        total_ratings += trip.rating
      end

      if trips.length == 0
        average = 0
      else
        average = (total_ratings.to_f) / trips.length
      end

      return average
    end

    def add_trip(trip)
      if trip.class != Trip
        raise ArgumentError.new("Can only add trip instance to trip collection")
      end

      @trips << trip
    end

    def get_total_revenue
      total_rev = 0.0
      @trips.each do |trip|
        if trip.cost != nil
          trip_cost = (trip.cost - 1.65) * 0.8
          total_rev += trip_cost.to_f
        end
      end
      return total_rev.round(2)
    end

    def total_hours_driving
      total_seconds = 0.0
      @trips.each do |trip|
        if trip.end_time != nil
          trip_time = trip.end_time - trip.start_time
          total_seconds += trip_time.round(2)
        end
      end
      total_hours = total_seconds / 3600
      return total_hours.round(2)
    end

    def avg_revenue_per_hour
      avg_rev_per_hour = get_total_revenue / total_hours_driving
      return avg_rev_per_hour.round(2)
    end

    def available?
      status == :AVAILABLE
    end

    def last_trip_not_nil?
      # binding.pry
      if @trips.empty?
        return true
      else
        @trips.last.end_time != nil
      end
    end

    # # select driver whose most recent trip ended the longest time ago
    # def driver_with_oldest_trips(input_array)
    #   driver_with_oldest_trip = nil
    #   oldest_trip_time = nil
    #   input_array.each do |driver|
    #     if driver.trips.last.end_time < oldest_trip_time
    #       oldest_trip_time = driver.trips.last.end_time
    #       driver_with_oldest_trip = driver
    #     end
    #   end
    #   return driver_with_oldest_trip
    # end

    def unavailable!
      @status = :UNAVAILABLE
    end
  end
end
