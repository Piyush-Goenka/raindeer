# frozen_string_literal: true

require 'low_event'
require 'observers'

require_relative '../support/config_loader'
require_relative 'stream'

module Rain
  class Matrix
    include Observers

    observe Low::Events::EventPool

    def initialize(event_pool:, config: Rain::ConfigLoader.load('../../config/matrix.yaml'))
      @event_pool = event_pool
      @config = config

      @screen_size = nil

      @last_stream_index = -1
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
      @streams.each_value { |stream| stream.render }

      (0...@screen_size[:row_count]).each do |row_index|
        cell_outputs = []
        cell_colors = []

        (0...@screen_size[:column_count]).each do |column_index|
          cell_colors << @columns[column_index].colors[row_index]
          cell_outputs << @columns[column_index].outputs[row_index]
        end

        output = cell_outputs.zip(cell_colors).map do |cell, color|
          cell ? Paint[cell, color] : Paint[' ', nil]
        end.join(' ')

        puts output
      end
    end

    def upsert_stream(stream_id:, event_tree:)
      @streams[stream_id] ||= Stream.new(index:, config: @config, event_tree:)
    end

    def index
      case @config.start_col
      when :random
        rand(0...@screen_size[:column_count])
      when :latest
        @last_stream_index += 1
        return @last_stream_index = 0 if @last_stream_index >= @screen_size[:column_count]
        @last_stream_index
      end
    end
  end
end
