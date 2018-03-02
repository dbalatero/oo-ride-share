require 'csv'
require_relative 'trip'

module RideShare
  class Driver
    attr_reader :id, :name, :vehicle_id, :status, :trips

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
      total_rev = @trips.map { |trip| (trip.cost - 1.65) * 0.8}.inject(0, :+)
      return total_rev.round(2)
    end

    def total_hours_driving
      total_seconds = @trips.map{ |trip| trip.end_time - trip.start_time}.inject(0, :+)
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

    def unavailable!
      @status = :UNAVAILABLE
    end
  end
end
