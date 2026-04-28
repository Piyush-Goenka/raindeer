# frozen_string_literal: true

require 'low_event'
require 'observers'

require_relative 'stream'

module Rain
  class Matrix
    include Observers

    observe Low::Events::EventPool

    CELL_COLOR = '#0071BB' # '#0098fc'

    def initialize(event_pool:, index_type: :random)
      @event_pool = event_pool

      @index_type = index_type
      @current_index = -1

      @screen_size = nil
      @streams = {}
      @columns = []
    end

    def render(screen_size:)
      if screen_size != @screen_size
        @screen_size = screen_size
        redraw_streams
      end

      render_streams
    end

    def update(stream_id:, event_tree:)
      upsert_stream(stream_id:, event_tree:)
    end

    private

    def redraw_streams
      @event_pool.event_trees.each do |stream_id, event_tree|
        stream = upsert_stream(stream_id:, event_tree:)
        stream.redraw(cell_count: @screen_size[:row_count])

        @columns[stream.index] = upsert_stream(stream_id:, event_tree:)
      end
    end

    def render_streams
      (0...@screen_size[:row_count]).each do |row_index|
        current_line = []
        next_line = []

        (0...@screen_size[:column_count]).each do |column_index|
          current_line << @columns[column_index].characters[row_index]
          next_line << @columns[column_index].characters[row_index + 1]
        end

        output = current_line.map do |cell|
          if cell.character && cell.render_at > 
            Paint[cell.character, CELL_COLOR]
          else
            Paint['', nil]
          end
        end.join(' ')

        puts output
      end
    end

    def color(timestamp:)
      duration = Time.now.to_i - timestamp
      CELL_COLORS[duration]
    end

    def upsert_stream(stream_id:, event_tree:)
      @streams[stream_id] ||= Stream.new(index:, event_tree:)
    end

    def index
      case @index_type
      when :random
        rand(0...@screen_size[:column_count])
      when :latest
        @current_index += 1
        return @current_index = 0 if @current_index >= @screen_size[:column_count]
        @current_index
      end
    end
  end
end
