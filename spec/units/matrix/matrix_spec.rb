# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/matrix'
require_relative '../../factories/event_factory'
require_relative '../../fixtures/mock_events'

RSpec.describe Rain::Matrix do
  subject(:rain_matrix) { described_class.new(event_pool:) }

  let(:event_pool) { instance_double(Low::Events::EventPool, event_trees:) }
  let(:event_trees) do
    {
      1 => Fixtures::EventFactory.create_event_tree,
      2 => Fixtures::EventFactory.create_event_tree,
      3 => Fixtures::EventFactory.create_event_tree,
    }
  end

  context 'with events' do
    let(:screen_size) { { columns: 3, lines: 50 } }

    it 'returns a matrix' do
      expect(rain_matrix.render(screen_size:)).to eq('asdf')
    end
  end
end
