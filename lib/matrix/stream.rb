# frozen_string_literal: true

require 'paint'

module Rain
  class Stream
    attr_reader :index

    ARROW = ['│', '▼']

    def initialize(index:, event_tree:)
      @index = index
      @event_tree = event_tree

      @characters = []
      @timestamps = []

      @current_cell = 0
      @current_event = 0
    end

    def redraw(cell_count:)
      @characters.fill(nil, 0...cell_count)

      (@current_event...@event_tree.sequence.count).each do |event_index|
        event = @event_tree.sequence[event_index]
        redraw_event(event:, separator: ARROW)
        @current_event += 1
      end

      @characters
    end

    def renderable(index:)
      { character: @characters[index], timestamp: @timestamps[index] }
    end

    private

    def redraw_event(event:, separator:)
      separator = [] if @current_event == 0
      stream = [*separator, *event_name(event:)]

      stream.each do |char|
        @characters[@current_cell] = char
        @timestamps[@current_cell] = event.created_at

        @current_cell += 1
        @current_cell = 0 if @current_cell == @characters.count
      end
    end

    def event_name(event:)
      event.class.name.split('::').last.delete_suffix('Event').chars
    end
  end
end
