# frozen_string_literal: true

require 'paint'

require_relative '../support/config_loader'
require_relative 'stream'

module Rain
  class Matrix
    def initialize(event_pool:, config: ConfigLoader.load('./config/matrix.yaml'))
      @event_pool = event_pool
      @config = config

      @screen_size = nil

      @last_stream_index = -1
      @streams = {} # TODO: Could be a "stream pool" like event pool (a pool hash).
      @columns = []
    end

    def redraw
      @event_pool.event_trees.each do |stream_id, event_tree|
        redraw_stream(stream_id:, event_tree:)
      end
    end

    def render(screen_size:, show_output: true)
      if screen_size != @screen_size
        @screen_size = screen_size
        redraw
      end

      render_streams(show_output:)
    end

    private

    def render_streams(show_output: true)
      @streams.each_value { |stream| stream.render }

      (0...@screen_size[:row_count]).each do |row_index|
        cell_outputs = []
        cell_colors = []

        # Rendering streams can happen before redrawing streams, so @columns may not be populated yet.
        (0...@screen_size[:column_count]).each do |column_index|
          cell_colors << (@columns[column_index].nil? ? nil : @columns[column_index].colors[row_index])
          cell_outputs << (@columns[column_index].nil? ? nil : @columns[column_index].outputs[row_index])
        end

        output = cell_outputs.zip(cell_colors).map do |cell, color|
          cell ? Paint[cell, color] : Paint[' ', nil]
        end.join(' ')

        puts output if show_output
      end
    end

    def redraw_stream(stream_id:, event_tree:)
      stream = @streams[stream_id] ||= Stream.new(index:, config: @config, event_tree:)
      stream.redraw(cell_count: @screen_size[:row_count])
      @columns[stream.index] = stream
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
