require 'csv'

module RideShare
  class Trip
    attr_reader :id, :passenger, :driver, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = check_start_time(input[:start_time])
      @end_time = check_end_time(input[:end_time])
      @cost = check_cost(input[:cost])
      @rating = check_rating(input[:rating])

      check_time

    end

    def duration
      @end_time - @start_time
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)}>"
    end

    private

    def check_cost(cost_input)
      if cost_input == nil
        return nil
      else
        return cost_input.to_f
      end
    end

    def check_rating(rating_input)
      if rating_input != nil
        if rating_input > 5 || rating_input < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        else
          @rating = rating_input
        end
      end
    end

    def check_time
      if (@end_time != nil && @start_time != nil) && (@end_time != @start_time)
        if @end_time < @start_time
          raise ArgumentError.new("Start time must be before end time.")
        end
      end
    end

    def check_start_time(start_time_input)
      if start_time_input.class == String
        @start_time = Time.parse(start_time_input)
      else
        @start_time = start_time_input
      end
      return @start_time
    end

    def check_end_time(end_time_input)
      if end_time_input.class == String
        @end_time = Time.parse(end_time_input)
      else
        @end_time = end_time_input
      end
      return @end_time
    end

  end
end
