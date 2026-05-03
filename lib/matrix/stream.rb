# frozen_string_literal: true

require_relative 'cursor'

module Rain
  class Stream
    attr_reader :index, :colors, :outputs

    ARROW = ['│', '▼']
    CELL_COLOR = '#0098fc'
    LEADING_CELL_COLOR = '#fff'
    
    # @param min_delay: Miliseconds - Slightly longer than the 33.33 miliseconds of each frame.
    def initialize(index:, min_delay: 34, event_tree:)
      @index = index

      @event_tree = event_tree
      @event_cursor = 0

      @redraw_cursor = 0
      @min_delay = min_delay

      @inputs = []
      @delays = []
      @colors = []
      @outputs = []

      @head_cursor = Cursor.new
      @tail_cursor = Cursor.new
      @head_last_update = now
      @tail_last_update = now
    end

    def redraw(cell_count:)
      @inputs.fill(nil, 0...cell_count)[0...cell_count]
      @delays.fill(@min_delay, 0...cell_count)[0...cell_count]
      @colors.fill(CELL_COLOR, 0...cell_count)[0...cell_count]

      (@event_cursor...@event_tree.sequence.count).each do |event_index|
        current_event = @event_tree.sequence[event_index]
        past_event = @event_tree.sequence[event_index - 1]

        redraw_event(current_event:, past_event:)
        @event_cursor += 1
      end

      @inputs
    end

    # Render a cell's input as output after a delay, using cursors.
    # ┌─┐
    # │R│ <-- Each cell is represented as an input, delay and output.
    # │e│
    # │q│ <-- The head cursor outputs the cell's input after a delay and colors the leading cell white.
    # │ │
    # │ │ <-- The tail cursor does the same thing but the input (and therefore output) will be empty.
    # └─┘     The tail cursor can be before or after the head cursor depending on whether events wrap around.
    def render(duration: nil)
      @head_cursor.increment(delays:, inputs:) do |index|
        prev_index = (index - 1).clamp(0, nil)
        next_index = index >= @inputs.count ? 0 : index + 1

        if @inputs[index]
          @outputs[index] = @inputs[index]
          @delays[index] = FADE_DELAY
          @colors[prev_index] = CELL_COLOR if @colors[prev_index]
          @colors[index] = @outputs[next_index] ? CELL_COLOR : LEADING_CELL_COLOR
          @inputs[index] = nil
        end
      end

      # @tail_cursor = move_cursor(cursor: @tail_cursor, duration: duration || now - @tail_last_update)
    end

    private

    attr_reader :inputs, :delays

    def now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    end

    # A column of cells representing sequential events.
    # ┌─┐
    # │R│  FIRST EVENT
    # │e│  Each cell will render input as output after a delay (that is just above frame rate) since there's no prior event.
    # │q│
    # │u│ 
    # │e│
    # │s│
    # │t│
    # └─┘ <-- Time has passed between events.
    # ┌─┐
    # │││  SECOND EVENT
    # │▼│  The next event has data to work with, it can represent the time it took to get from the previous event to the next.
    # │R│  Each cell will render for the following delay; the time elapsed between events divided by the number of inputs.
    # │o│
    # │u│ <-- A cursor moves to the next cell after a delay and colors the leading cell white.
    # │t│
    # │e│
    # └─┘
    def redraw_event(current_event:, past_event:)
      if @event_cursor == 0
        inputs = event_name(current_event:)
        delay = @min_delay
      else
        inputs = [*ARROW, *event_name(current_event:)]
        difference = current_event.created_at - past_event.created_at
        delay = difference == 0 ? @min_delay : (difference / inputs.count).to_i.clamp(@min_delay, nil)
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
  end
end
