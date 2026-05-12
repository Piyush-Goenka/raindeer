# frozen_string_literal: true

module Rain
  class Cursor
    attr_accessor :index, :first_update, :last_update

    def initialize
      @index = 0
      @first_update = now
      @last_update = now
    end

    def increment(delays:, inputs:, duration: nil)
      duration = now - @last_update if duration.nil?

      return unless delays[index] && duration >= delays[index]

        @last_update = now

        yield index

        @index += 1
        @index = 0 if @index >= inputs.count
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end
  end
end
