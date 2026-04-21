# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/matrix'
require_relative '../../factories/event_factory'
require_relative '../../fixtures/mock_events'

RSpec.describe Rain::Matrix do
  subject(:rain_matrix) { described_class.new(stream_pool:, screen_size:) }

  let(:stream_pool) { instance_double(Low::Streams::StreamPool, streams:) }
  let(:streams) do
    {
      1 => Low::Fixtures::EventFactory.create_stream,
    }
  end

  context 'with streams' do
    let(:screen_size) { columns: 3, lines: 50 }

    it 'returns a matrix' do
      expect(rain_matrix.columns).to eq([
        [RequestEvent.new, RouteEvent.new, RenderEvent.new, ResponseEvent.new]
        [RequestEvent.new, RouteEvent.new, RenderEvent.new, ResponseEvent.new]
        [RequestEvent.new, RouteEvent.new, RenderEvent.new, ResponseEvent.new]
      ])
    end
  end
end
