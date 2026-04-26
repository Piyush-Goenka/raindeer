# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/matrix'
require_relative '../../factories/event_factory'
require_relative '../../fixtures/mock_events'

def loop_output
  return

  7.times do
    system 'clear'
    rain_matrix.render(screen_size:)
    sleep 1
  end
end

RSpec.describe Rain::Matrix do
  subject(:rain_matrix) { described_class.new(event_pool:, index_type:) }

  let(:event_pool) { instance_double(Low::Events::EventPool, event_trees:) }
  let(:event_trees) do
    {
      1 => Fixtures::EventFactory.request_response_tree,
      2 => Fixtures::EventFactory.request_response_tree,
      3 => Fixtures::EventFactory.request_response_tree,
    }
  end

  context 'when 1 column' do
    let(:screen_size) { { column_count: 1, row_count: 20 } }
    let(:index_type) { :random }

    let(:lines) do
      <<~BASH
        #{[['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['q', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['u', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['t', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['│', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['▼', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['p', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['o', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['n', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
      BASH
    end
  
    it 'returns a matrix' do
      expect { rain_matrix.render(screen_size:) }.to output(lines).to_stdout
      loop_output
    end
  end

  context 'when 2 columns' do
    let(:screen_size) { { column_count: 2, row_count: 20 } }
    let(:index_type) { :latest }

    let(:lines) do
      <<~BASH
        #{[['R', '#fff'], ['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['q', '#fff'], ['q', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['u', '#fff'], ['u', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['t', '#fff'], ['t', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['│', '#fff'], ['│', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['▼', '#fff'], ['▼', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['R', '#fff'], ['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['p', '#fff'], ['p', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['o', '#fff'], ['o', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['n', '#fff'], ['n', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
      BASH
    end
  
    it 'returns a matrix' do
      expect { rain_matrix.render(screen_size:) }.to output(lines).to_stdout
      loop_output
    end
  end

  context 'when events created seconds apart' do
    let(:index_type) { :latest }
    let(:event_trees) do
      {
        1 => Fixtures::EventFactory.request_response_tree(created_at:, step: 1),
        2 => Fixtures::EventFactory.request_response_tree(created_at:, step: 2),
        3 => Fixtures::EventFactory.request_response_tree(created_at:, step: 3),
      }
    end

    let(:created_at) { Time.now.to_i }

    before do
      Timecop.freeze(created_at)
    end

    after do
      Timecop.unfreeze
    end

    context 'when 1 column' do
      let(:screen_size) { { column_count: 3, row_count: 20 } }

      let(:lines) do
        <<~BASH
        #{[['R', '#fff'], ['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['q', '#fff'], ['q', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['u', '#fff'], ['u', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['t', '#fff'], ['t', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['│', '#fff'], ['│', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['▼', '#fff'], ['▼', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['R', '#fff'], ['R', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['p', '#fff'], ['p', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['o', '#fff'], ['o', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['n', '#fff'], ['n', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['s', '#fff'], ['s', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['e', '#fff'], ['e', '#fff']].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        #{[['',        ], ['',        ]].map { |l| Paint[l[0], l[1]] }.join(' ')}
        BASH
      end
    
      it 'returns a matrix' do
        expect { rain_matrix.render(screen_size:) }.to output(lines).to_stdout
        loop_output
      end
    end
  end
end
