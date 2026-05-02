# frozen_string_literal: true

require 'low_event'
require 'observers'

require_relative 'stream'

module Rain
  class Matrix
    include Observers

    observe Low::Events::EventPool

    CELL_COLOR = '#0098fc'

    def initialize(event_pool:, index_type: :random, min_delay: nil)
      @event_pool = event_pool

      @index_type = index_type
      @current_index = -1
      @min_delay = min_delay

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
      @streams.each_value { it.render }

      (0...@screen_size[:row_count]).each do |row_index|
        row_cells = []

        (0...@screen_size[:column_count]).each do |column_index|
          row_cells << @columns[column_index].outputs[row_index]
        end

        output = row_cells.map do |cell|
          cell ? Paint[cell, CELL_COLOR] : Paint['', nil]
        end.join(' ')

        puts output
      end
    end

    def upsert_stream(stream_id:, event_tree:)
      @streams[stream_id] ||= Stream.new(index:, min_delay: @min_delay, event_tree:)
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
