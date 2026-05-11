# frozen_string_literal: true

require 'low_event'
require 'observers'

require_relative 'cursor'

module Rain
  class Stream
    include Observers

    attr_reader :index, :inputs, :outputs, :colors

    ARROW = ['│', '▼']

    def initialize(index:, config:, event_tree:)
      @index = index
      @config = config
      @event_tree = event_tree

      @inputs = []
      @delays = []
      @colors = []
      @outputs = []

      # Redraw.
      @event_cursor = 0
      @redraw_cursor = 0

      # Render.
      @head_cursor = Cursor.new
      @tail_cursor = Cursor.new

      observe event_tree
    end

    def branch(event: Low::Events::BranchEvent)
      redraw(cell_count: @inputs.count)
    end

    # Draw event names onto the current amount of cells in a stream.
    def redraw(cell_count:)
      old_index = (@inputs.count - 1).clamp(0, nil)

      @inputs.fill(nil, old_index...cell_count)[0...cell_count]
      @delays.fill(@config.min_delay, old_index...cell_count)[0...cell_count]
      @colors.fill(@config.cell_color, old_index...cell_count)[0...cell_count]

      (@event_cursor...@event_tree.sequence.count).each do |event_index|
        current_event = @event_tree.sequence[event_index]
        past_event = @event_tree.sequence[event_index - 1]

        redraw_event(current_event:, past_event:)
        @event_cursor += 1
      end
    end

    # Render a cell's input as output after a delay, using cursors. Called on every frame.
    # ┌─┐
    # │R│ <-- Each cell is represented as an input, delay and output.
    # │e│
    # │q│ <-- The head cursor outputs the cell's input after a delay and colors the leading cell white.
    # │ │
    # │ │ <-- The tail cursor does the same thing but the input (and therefore output) will be empty.
    # └─┘     The tail cursor can be before or after the head cursor depending on whether events wrap around.
    #
    # Unit tests use "duration" to skip forwards in time, while matrix spec and the real world use old fashioned linear time.
    def render(duration: nil)
      @head_cursor.increment(delays:, inputs:, duration:) do |index|
        prev_index = index == 0 ? @inputs.count - 1 : index - 1
        next_index = index + 1 >= @inputs.count ? 0 : index + 1

        if @inputs[index]
          @outputs[index] = @inputs[index]
          @delays[index] = @config.fade_delay
          @colors[prev_index] = @config.cell_color if @colors[prev_index]
          @colors[index] = @outputs[next_index] ? @config.cell_color : @config.lead_color
          @inputs[index] = nil
        end
      end

      fade(duration:) if @config.fade
    end

    private

    attr_reader :delays

    def fade(duration: nil)
      fade_start = rand(5_000..10_000)

      if (now - @head_cursor.first_update) >= fade_start || (duration && duration >= fade_start)
        @tail_cursor.increment(delays:, inputs:, duration:) do |index|
          if @inputs[index].nil? && @outputs[index]
            @outputs[index] = @inputs[index]
            @delays[index] = 0
          end
        end
      end
    end

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end

    # A column of cells representing sequential events.
    # ┌─┐
    # │R│  FIRST EVENT
    # │e│  Each cell will render input as output after a minimum delay (since there's no prior event).
    # │q│
    # │u│ 
    # │e│
    # │s│
    # │t│
    # └─┘ <-- Time has passed between events.
    # ┌─┐
    # │││  SECOND EVENT
    # │▼│  The next event has data to work with, it can represent the time it took to get from the previous event to the next.
    # │R│  Each cell will render after the largest duration of the following values:
    # │o│   1. The minimum delay
    # │u│   2. The time elapsed between events divided by the number of inputs
    # │t│
    # │e│ <-- A cursor moves to the next cell after a delay and colors the leading cell white.
    # └─┘
    def redraw_event(current_event:, past_event:)
      if @event_cursor == 0
        inputs = event_name(current_event:)
        delay = @config.min_delay

        randomize_start_row if @config.start_row == :random
      else
        inputs = [*ARROW, *event_name(current_event:)]
        difference = current_event.created_at - past_event.created_at
        delay = difference == 0 ? @config.min_delay : (difference / inputs.count).to_i.clamp(@config.min_delay, nil)
      end

      inputs.each do |character|
        @inputs[@redraw_cursor] = character
        @delays[@redraw_cursor] = @redraw_cursor == 0 ? 0 : delay # Don't add delay to the first cell, looks stuck.

        @redraw_cursor += 1
        @redraw_cursor = 0 if @redraw_cursor >= @inputs.count
      end
    end

    def event_name(current_event:)
      current_event.class.name.split('::').last.delete_suffix('Event').chars
    end

    def randomize_start_row
      random_index = rand(0..2) 
      @redraw_cursor = random_index
      @head_cursor.index = random_index - 1 # Head cursor always 1 index behind to make "increment" method's logic simple.
    end
  end
end
