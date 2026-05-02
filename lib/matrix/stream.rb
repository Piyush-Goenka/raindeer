# frozen_string_literal: true

module Rain
  class Stream
    attr_reader :index
    attr_accessor :inputs, :delays, :outputs

    ARROW = ['│', '▼']
    MIN_DELAY = 34 # miliseconds

    def initialize(index:, event_tree:)
      @index = index

      @event_tree = event_tree
      @event_cursor = 0
      @redraw_cursor = 0

      @inputs = []
      @delays = []
      @outputs = []

      @tail_cursor = 0
      @head_cursor = 0
    end

    def redraw(cell_count:)
      @inputs.fill(nil, 0...cell_count)

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
    # │││  CELLS
    # │▼│  Each cell is represented as an input, delay and output.
    # │R│
    # │o│
    # │u│ <-- The head cursor outputs the input after a delay and colors the leading cell white.
    # │ │     The tail cursor does the same thing but the input (and therefore output) will be empty.
    # └─┘
    def render(cell_index:, duration:)
      # TODO.
    end

    private

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
        delay = MIN_DELAY
      else
        inputs = [*ARROW, *event_name(current_event:)]
        difference = current_event.created_at - past_event.created_at
        delay = difference == 0 ? MIN_DELAY : (difference / inputs.count).to_i.clamp(MIN_DELAY, nil)
      end

      inputs.each do |character|
        @inputs[@redraw_cursor] = character
        @delays[@redraw_cursor] = delay

        @redraw_cursor += 1
        @redraw_cursor = 0 if @redraw_cursor == @inputs.count
      end
    end

    def event_name(current_event:)
      current_event.class.name.split('::').last.delete_suffix('Event').chars
    end
  end
end
