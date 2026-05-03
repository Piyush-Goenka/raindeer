# frozen_string_literal: true

module Rain
  class Cursor
    attr_accessor :index, :last_update

    def initialize
      @index = -1
      @last_update = now
      @first_update = now
    end

    def increment(delays:, inputs:, duration: now - @last_update)
      next_index = @index + 1

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
