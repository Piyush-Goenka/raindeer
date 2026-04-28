# frozen_string_literal: true

module Rain
  class Stream
    attr_reader :index
    attr_accessor :characters, :durations, :renders

    ARROW = ['│', '▼']
    MIN_DURATION = 34 # miliseconds

    def initialize(index:, event_tree:)
      @index = index

      @event_tree = event_tree
      @event_cursor = 0

      @characters = []
      @durations = []
      @renders = []

      @redraw_cursor = 0
      @render_cursor = 0
    end

    def redraw(cell_count:)
      @characters.fill(nil, 0...cell_count)

      (@event_cursor...@event_tree.sequence.count).each do |event_index|
        current_event = @event_tree.sequence[event_index]
        past_event = @event_tree.sequence[event_index - 1]

        redraw_event(current_event:, past_event:)

        @event_cursor += 1
      end

      @characters
    end

    private

    # A column of characters representing events that appear sequentially and render in and out as an animation.
    # ┌─┐
    # │R│  FIRST EVENT
    # │e│  Each cell has a minimum duration just above frame rate since there's no prior event.
    # │q│
    # │u│ 
    # │e│
    # │s│
    # │t│
    # └─┘ <-- Time has passed between events.
    # ┌─┐
    # │││  SECOND EVENT
    # │▼│  Each cell renders for the following duration; the time elapsed between events divided by the number of characters.
    # │R│
    # │o│
    # │u│ <-- A cursor increments for each cell after every cell duration and colors the leading cell white.
    # │t│
    # │e│
    # └─┘
    def redraw_event(current_event:, past_event:)
      if @event_cursor == 0
        characters = event_name(current_event:)
        duration = MIN_DURATION
      else
        characters = [*ARROW, *event_name(current_event:)]
        difference = current_event.created_at - past_event.created_at
        duration = difference == 0 ? MIN_DURATION : (difference / characters.count).to_i.clamp(MIN_DURATION, nil)
      end

      characters.each do |character|
        @characters[@redraw_cursor] = character
        @durations[@redraw_cursor] = duration

        @redraw_cursor += 1
        @redraw_cursor = 0 if @redraw_cursor == @characters.count
      end
    end

    def event_name(current_event:)
      current_event.class.name.split('::').last.delete_suffix('Event').chars
    end
  end
end
