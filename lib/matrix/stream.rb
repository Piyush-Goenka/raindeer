# frozen_string_literal: true

require 'low_event'
require 'observers'

require_relative 'cursor'

module Rain
  class Stream
    include Observers

    attr_reader :index, :inputs, :outputs, :colors

    ARROW = ['│', '▼'].freeze

    def initialize(index:, config:, event_tree:)
      @index = index
      @config = config
      @event_tree = event_tree

      @inputs = []
      @delays = []
      @colors = []
      @outputs = []

      @event_cursor = 0
      @redraw_head_cursor = Cursor.new
      @redraw_tail_cursor = Cursor.new

      @render_head_cursor = Cursor.new
      @render_tail_cursor = Cursor.new

      observe event_tree
    end

    # TODO: Use "on :branch do |event|" syntax.
    def branch(event: Low::Events::BranchEvent) # rubocop:disable Lint/UnusedMethodArgument
      redraw(cell_count: @inputs.count)
    end

    # Draw event names onto the current amount of cells in a stream, using cursors. Called when there's a new event.
    #
    #  INPUT DELAY OUTPUT
    # ┌─────┬─────┬─────┐
    # │  R  │  75 │     │ ◀── 2. Redraw tail cursor begins at index zero or a random starting index.
    # │  e  │  75 │     │        A redraw head cursor that wraps around will push the redraw tail cursor down to be just beneath it.
    # │  q  │  75 │     │        The render head cursor will start at the redraw tail cursor index.
    # │  u  │  75 │     │ 
    # │     │  75 │     │ ◀── 1. Redraw head cursor begins at index zero or a random starting index.
    # │     │  75 │     │        It populates input for every character in an event name.
    # │     │  75 │     │        Then sets a "75" delay for the render head cursor.
    # └─────┴─────┴─────┘
    #
    def redraw(cell_count:)
      randomize_start_index if first_cell_redraw? && @config.start_row == :random

      # TODO: Test that these arrays are correctly being resized.
      old_index = (@inputs.count - 1).clamp(0, nil)
      @inputs = @inputs.fill(nil, old_index...cell_count)[0...cell_count]
      @delays = @delays.fill(@config.min_delay, old_index...cell_count)[0...cell_count]
      @colors = @colors.fill(@config.cell_color, old_index...cell_count)[0...cell_count]

      (@event_cursor...@event_tree.sequence.count).each do |event_index|
        current_event = @event_tree.sequence[event_index]
        past_event = @event_tree.sequence[event_index - 1]

        redraw_event(current_event:, past_event:)
        @event_cursor += 1
      end
    end

    # Render a cell's input as output after a delay, using cursors. Called on every frame.
    #
    #  INPUT DELAY OUTPUT
    # ┌─────┬─────┬─────┐
    # │     │ 250 │     │ ◀── 2. Render tail cursor moves the input to the output after a delay.
    # │     │ 250 │  e  │        The nil input replaces the previous output of "R".
    # │     │ 250 │  q  │
    # │     │  75 │  u  │ ◀── 1. Render head cursor moves the input to the output after a delay.
    # │  e  │  75 │     │        Leaving behind nil input.
    # │  s  │  75 │     │        Then sets a "250" delay for the render tail cursor.
    # │  t  │  75 │     │
    # └─────┴─────┴─────┘
    def render(duration: nil)
      @render_head_cursor.increment(delays:, inputs:, duration:) do |index|
        prev_index = index.zero? ? @inputs.count - 1 : index - 1
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

      return unless (now - @render_head_cursor.first_update) >= fade_start || (duration && duration >= fade_start)

      @render_tail_cursor.increment(delays:, inputs:, duration:) do |index|
        if @inputs[index].nil? && @outputs[index]
          @outputs[index] = @inputs[index]
          @delays[index] = 0
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
    # └─┘ ◀── Time has passed between events.
    # ┌─┐
    # │││  SECOND EVENT
    # │▼│  The next event has data to work with, it can represent the time it took to get from the previous event to the next.
    # │R│  Each cell will delay render for the larger duration of either:
    # │o│   1. The minimum delay
    # │u│   2. The time elapsed between events divided by the number of cells
    # │t│
    # │e│ ◀── A cursor moves to the next cell after a delay and colors the leading cell white.
    # └─┘
    def redraw_event(current_event:, past_event:)
      variable_delay = variable_delay(current_event:, past_event:)

      characters = event_name(current_event:)
      characters = [*ARROW, *characters] if @event_cursor > 0
      
      @redraw_head_cursor.iterate(inputs: characters, loop_count: @inputs.count) do |index, input|
        @inputs[index] = input
        @delays[index] = first_cell_redraw? ? 0 : variable_delay # Don't add delay to the first cell, looks stuck.
      end
    end

    def variable_delay(current_event:, past_event:)
      if @event_cursor.zero?
        @config.min_delay
      else
        difference = current_event.created_at - past_event.created_at
        difference.zero? ? @config.min_delay : (difference / inputs.count).to_i.clamp(@config.min_delay, nil)
      end
    end

    def event_name(current_event:)
      current_event.class.name.split('::').last.delete_suffix('Event').chars
    end

    def first_cell_redraw?
      # Once redraw head cursor gets away from redraw tail cursor, they should never be equal again.
      @redraw_head_cursor.index == @redraw_tail_cursor.index
    end

    def randomize_start_index
      random_index = rand(0..2)

      @redraw_head_cursor.index = random_index
      @redraw_tail_cursor.index = random_index

      @render_head_cursor.index = random_index
      @render_tail_cursor.index = random_index - 1 # Waits behind the delay set by the render head cursor.
    end
  end
end
