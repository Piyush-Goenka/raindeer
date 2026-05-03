# frozen_string_literal: true

require 'paint'
require 'low_event'

require_relative '../../../lib/matrix/matrix'
require_relative '../../factories/event_factory'
require_relative '../../fixtures/mock_events'

def render_frames(frames = 100, fps = 30)
  return if ENV['CI']

  frame_duration = 1.0 / fps

  frames.times do
    system 'clear'
    matrix.render(screen_size:)
    sleep(frame_duration)
  end
end

class Array
  def paint_columns
    self.map { ::Paint[it[0], it[1]] }.join(' ')
  end
end

RSpec.describe Rain::Matrix do
  subject(:matrix) { described_class.new(event_pool:, index_type:, min_delay: 75, fade:) }

  let(:event_pool) { instance_double(Low::Events::EventPool, event_trees:) }
  let(:event_trees) do
    {
      1 => Fixtures::EventFactory.request_response_tree,
      2 => Fixtures::EventFactory.request_response_tree,
      3 => Fixtures::EventFactory.request_response_tree,
    }
  end

  let(:index_type) { :latest }
  let(:fade) { false }

  let(:cell_color) { '#0098fc' }
  let(:lead_color) { '#ffffff' }

  context 'when 1 column' do
    let(:screen_size) { { column_count: 1, row_count: 20 } }
    let(:index_type) { :random }

    let(:lines) do
      <<~BASH
        #{[['R', cell_color]].paint_columns}
        #{[['e', cell_color]].paint_columns}
        #{[['q', cell_color]].paint_columns}
        #{[['u', cell_color]].paint_columns}
        #{[['e', cell_color]].paint_columns}
        #{[['s', cell_color]].paint_columns}
        #{[['t', cell_color]].paint_columns}
        #{[['│', cell_color]].paint_columns}
        #{[['▼', cell_color]].paint_columns}
        #{[['R', cell_color]].paint_columns}
        #{[['e', cell_color]].paint_columns}
        #{[['s', cell_color]].paint_columns}
        #{[['p', cell_color]].paint_columns}
        #{[['o', cell_color]].paint_columns}
        #{[['n', cell_color]].paint_columns}
        #{[['s', cell_color]].paint_columns}
        #{[['e', lead_color]].paint_columns}
        #{[[' ',           ]].paint_columns}
        #{[[' ',           ]].paint_columns}
        #{[[' ',           ]].paint_columns}
      BASH
    end
  
    it 'returns a matrix' do
      render_frames
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end

  context 'when 2 columns' do
    let(:screen_size) { { column_count: 2, row_count: 20 } }

    let(:lines) do
      <<~BASH
        #{[['R', cell_color], ['R', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['q', cell_color], ['q', cell_color]].paint_columns}
        #{[['u', cell_color], ['u', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['t', cell_color], ['t', cell_color]].paint_columns}
        #{[['│', cell_color], ['│', cell_color]].paint_columns}
        #{[['▼', cell_color], ['▼', cell_color]].paint_columns}
        #{[['R', cell_color], ['R', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['p', cell_color], ['p', cell_color]].paint_columns}
        #{[['o', cell_color], ['o', cell_color]].paint_columns}
        #{[['n', cell_color], ['n', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['e', lead_color], ['e', lead_color]].paint_columns}
        #{[[' ',           ], [' ',           ]].paint_columns}
        #{[[' ',           ], [' ',           ]].paint_columns}
        #{[[' ',           ], [' ',           ]].paint_columns}
      BASH
    end
  
    it 'returns a matrix' do
      render_frames
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end

  context 'when events created seconds apart' do
    let(:screen_size) { { column_count: 3, row_count: 20 } }
    let(:event_trees) do
      {
        1 => Fixtures::EventFactory.request_response_tree(created_at: created_at),
        2 => Fixtures::EventFactory.request_response_tree(created_at: created_at + 1000),
        3 => Fixtures::EventFactory.request_response_tree(created_at: created_at + 2000),
      }
    end

    let(:created_at) { Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond) }

    let(:lines) do
      <<~BASH
        #{[['R', cell_color], ['R', cell_color], ['R', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['q', cell_color], ['q', cell_color], ['q', cell_color]].paint_columns}
        #{[['u', cell_color], ['u', cell_color], ['u', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['t', cell_color], ['t', cell_color], ['t', cell_color]].paint_columns}
        #{[['│', cell_color], ['│', cell_color], ['│', cell_color]].paint_columns}
        #{[['▼', cell_color], ['▼', cell_color], ['▼', cell_color]].paint_columns}
        #{[['R', cell_color], ['R', cell_color], ['R', cell_color]].paint_columns}
        #{[['e', cell_color], ['e', cell_color], ['e', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['p', cell_color], ['p', cell_color], ['p', cell_color]].paint_columns}
        #{[['o', cell_color], ['o', cell_color], ['o', cell_color]].paint_columns}
        #{[['n', cell_color], ['n', cell_color], ['n', cell_color]].paint_columns}
        #{[['s', cell_color], ['s', cell_color], ['s', cell_color]].paint_columns}
        #{[['e', lead_color], ['e', lead_color], ['e', lead_color]].paint_columns}
        #{[[' ',           ], [' ',           ], [' ',           ]].paint_columns}
        #{[[' ',           ], [' ',           ], [' ',           ]].paint_columns}
        #{[[' ',           ], [' ',           ], [' ',           ]].paint_columns}
      BASH
    end

    it 'returns a matrix' do
      render_frames
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end

  context 'when events fade' do
    let(:fade) { true }
    let(:screen_size) { { column_count: 3, row_count: 20 } }

    let(:event_trees) do
      {
        1 => Fixtures::EventFactory.request_response_tree(created_at: created_at),
        2 => Fixtures::EventFactory.request_response_tree(created_at: created_at + 1000),
        3 => Fixtures::EventFactory.request_response_tree(created_at: created_at + 2000),
      }
    end
    let(:created_at) { Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond) }

    let(:lines) do
      <<~BASH
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
        #{[[' '], [' '], [' ']].paint_columns}
      BASH
    end

    it 'returns a matrix with no rows' do
      render_frames(250)

      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
      sleep(5)
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end
end
