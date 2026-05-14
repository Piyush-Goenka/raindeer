# frozen_string_literal: true

module Rain
  class Cursor
    attr_accessor :index, :first_update, :last_update

    def initialize
      @index = -1
      @first_update = now
      @last_update = now
    end

    # Unit tests use "duration" to skip forward in time, while feature tests and the real world use old fashioned linear time.
    def increment(delays:, inputs:, duration: nil)
      next_index = next_index(loop_count: inputs.count)

      return unless delays[next_index] && (duration || now - @last_update) >= delays[next_index]

      @index = next_index
      @last_update = now

      yield index
    end

    def iterate(inputs:, loop_count:)
      inputs.each do |input|
        @index += 1
        @index = 0 if index >= loop_count

        yield index, input
      end
    end

    def increase_index(loop_count:)
      @index += 1
      @index = 0 if @index >= loop_count
    end

    def next_index(loop_count:)
      next_index = @index + 1
      next_index = 0 if next_index >= loop_count
      next_index
    end

    private

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end
  end
end
