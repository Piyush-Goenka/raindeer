# frozen_string_literal: true

require 'paint'
require 'low_event'

require_relative '../../../lib/matrix/matrix'
require_relative '../../factories/event_factory'
require_relative '../../fixtures/mock_events'

def loop_output
  return if ENV['CI']

  250.times do
    system 'clear'
    matrix.render(screen_size:)
  end
end

class Array
  def paint_columns
    self.map { ::Paint[it[0], it[1]] }.join(' ')
  end
end

RSpec.describe Rain::Matrix do
  subject(:matrix) { described_class.new(event_pool:, index_type:, min_delay: 34) }

  let(:event_pool) { instance_double(Low::Events::EventPool, event_trees:) }
  let(:event_trees) do
    {
      1 => Fixtures::EventFactory.request_response_tree,
      2 => Fixtures::EventFactory.request_response_tree,
      3 => Fixtures::EventFactory.request_response_tree,
    }
  end

  let(:color) { '#0098fc' }

  context 'when 1 column' do
    let(:screen_size) { { column_count: 1, row_count: 20 } }
    let(:index_type) { :random }

    let(:lines) do
      <<~BASH
        #{[['R', color]].paint_columns}
        #{[['e', color]].paint_columns}
        #{[['q', color]].paint_columns}
        #{[['u', color]].paint_columns}
        #{[['e', color]].paint_columns}
        #{[['s', color]].paint_columns}
        #{[['t', color]].paint_columns}
        #{[['│', color]].paint_columns}
        #{[['▼', color]].paint_columns}
        #{[['R', color]].paint_columns}
        #{[['e', color]].paint_columns}
        #{[['s', color]].paint_columns}
        #{[['p', color]].paint_columns}
        #{[['o', color]].paint_columns}
        #{[['n', color]].paint_columns}
        #{[['s', color]].paint_columns}
        #{[['e', color]].paint_columns}
        #{[['',       ]].paint_columns}
        #{[['',       ]].paint_columns}
        #{[['',       ]].paint_columns}
      BASH
    end
  
    it 'returns a matrix' do
      loop_output
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end

  context 'when 2 columns' do
    let(:screen_size) { { column_count: 2, row_count: 20 } }
    let(:index_type) { :latest }

    let(:lines) do
      <<~BASH
        #{[['R', color], ['R', color]].paint_columns}
        #{[['e', color], ['e', color]].paint_columns}
        #{[['q', color], ['q', color]].paint_columns}
        #{[['u', color], ['u', color]].paint_columns}
        #{[['e', color], ['e', color]].paint_columns}
        #{[['s', color], ['s', color]].paint_columns}
        #{[['t', color], ['t', color]].paint_columns}
        #{[['│', color], ['│', color]].paint_columns}
        #{[['▼', color], ['▼', color]].paint_columns}
        #{[['R', color], ['R', color]].paint_columns}
        #{[['e', color], ['e', color]].paint_columns}
        #{[['s', color], ['s', color]].paint_columns}
        #{[['p', color], ['p', color]].paint_columns}
        #{[['o', color], ['o', color]].paint_columns}
        #{[['n', color], ['n', color]].paint_columns}
        #{[['s', color], ['s', color]].paint_columns}
        #{[['e', color], ['e', color]].paint_columns}
        #{[['',       ], ['',       ]].paint_columns}
        #{[['',       ], ['',       ]].paint_columns}
        #{[['',       ], ['',       ]].paint_columns}
      BASH
    end
  
    it 'returns a matrix' do
      loop_output
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end

  context 'when events created seconds apart' do
    let(:screen_size) { { column_count: 3, row_count: 20 } }
    let(:index_type) { :latest }
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
        #{[['R', color], ['R', color], ['R', color]].paint_columns}
        #{[['e', color], ['e', color], ['e', color]].paint_columns}
        #{[['q', color], ['q', color], ['q', color]].paint_columns}
        #{[['u', color], ['u', color], ['u', color]].paint_columns}
        #{[['e', color], ['e', color], ['e', color]].paint_columns}
        #{[['s', color], ['s', color], ['s', color]].paint_columns}
        #{[['t', color], ['t', color], ['t', color]].paint_columns}
        #{[['│', color], ['│', color], ['│', color]].paint_columns}
        #{[['▼', color], ['▼', color], ['▼', color]].paint_columns}
        #{[['R', color], ['R', color], ['R', color]].paint_columns}
        #{[['e', color], ['e', color], ['e', color]].paint_columns}
        #{[['s', color], ['s', color], ['s', color]].paint_columns}
        #{[['p', color], ['p', color], ['p', color]].paint_columns}
        #{[['o', color], ['o', color], ['o', color]].paint_columns}
        #{[['n', color], ['n', color], ['n', color]].paint_columns}
        #{[['s', color], ['s', color], ['s', color]].paint_columns}
        #{[['e', color], ['e', color], ['e', color]].paint_columns}
        #{[['',       ], ['',       ], ['',       ]].paint_columns}
        #{[['',       ], ['',       ], ['',       ]].paint_columns}
        #{[['',       ], ['',       ], ['',       ]].paint_columns}
      BASH
    end

    it 'returns a matrix' do
      loop_output
      expect { matrix.render(screen_size:) }.to output(lines).to_stdout
    end
  end
end
