# frozen_string_literal: true

require 'low_event'
require 'observers'
require 'paint'

require_relative '../support/config_loader'
require_relative 'stream'

module Rain
  class Matrix
    include Observers

    def initialize(event_pool:, config: ConfigLoader.load('./config/matrix.yaml'))
      @event_pool = event_pool
      @config = config

      @screen_size = nil

      @last_stream_index = -1
      @streams = {} # TODO: Could be a "stream pool" like event pool (a pool hash).
      @columns = []
    end

    def redraw(screen_size:)
      @setup ||= setup

      @streams.each_value do |stream|
        stream.redraw(cell_count: screen_size[:row_count])
      end
    end

    def render(screen_size:, show_output: true)
      if screen_size != @screen_size
        @screen_size = screen_size
        redraw(screen_size:)
      end

      render_streams(show_output:)
    end

    # TODO: Introduce "on :new_event_tree do |event|" block construct in LowEvent for making event handlers more obvious.
    # TODO: Observers should allow arbitrary params when triggering and observing.
    def new_event_tree(event: Low::Events::EventTree)
      stream = upsert_stream(event_tree: event)
      stream.redraw(cell_count: @screen_size[:row_count])
    end

    private

    def setup
      @event_pool.event_trees.each_value do |event_tree|
        upsert_stream(event_tree:)
      end

      observe @event_pool

      true
    end

    def upsert_stream(event_tree:)
      stream = @streams[event_tree.request_id] ||= Stream.new(index: generate_index, config: @config, event_tree:)
      @columns[stream.index] = stream
      stream
    end

    def render_streams(show_output: true)
      @streams.each_value { |stream| stream.render }

      system 'clear' if show_output

      (0...@screen_size[:row_count]).each do |row_index|
        cell_outputs = []
        cell_colors = []

        # Rendering streams can happen before redrawing streams, so @columns may not be populated yet.
        (0...(@screen_size[:column_count] / 2).to_i).each do |column_index|
          cell_colors << (@columns[column_index].nil? ? nil : @columns[column_index].colors[row_index])
          cell_outputs << (@columns[column_index].nil? ? nil : @columns[column_index].outputs[row_index])
        end

        output = cell_outputs.zip(cell_colors).map do |cell, color|
          cell ? Paint[cell, color] : Paint[' ']
        end.join(' ')

        puts output if show_output
      end
    end

    def generate_index
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
