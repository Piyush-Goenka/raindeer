# frozen_string_literal: true

module Rain
  class Cursor
    attr_accessor :index, :first_update, :last_update

    def initialize
      @index = -1
      @first_update = now
      @last_update = now
    end

    def increment(delays:, inputs:, duration: nil)
      next_index = @index + 1
      duration = now - @last_update if duration.nil?

      if delays[next_index] && duration >= delays[next_index]
        @index += 1
        @index = 0 if index >= inputs.count
        @last_update = now

        yield index
      end
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end
  end
end
