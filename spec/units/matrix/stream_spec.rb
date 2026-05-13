# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/stream'
require_relative '../../../lib/support/config_loader'
require_relative '../../factories/event_factory'

RSpec.describe Rain::Stream do
  subject(:stream) { described_class.new(index: 0, config:, event_tree:) }

  let(:config) { Rain::ConfigLoader.load('./spec/fixtures/config/matrix.yaml', config_overrides) }
  let(:config_overrides) { {} }
  let(:event_tree) { Fixtures::EventFactory.request_response_tree(request_id: 1) }

  describe '#redraw' do
    before do
      stream.redraw(cell_count:)
    end

    context 'when screen larger than stream' do
      let(:cell_count) { 20 }

      it 'inputs full stream' do
        expect(stream.inputs).to eq(
          ['R', 'e', 'q', 'u', 'e', 's', 't', '│', '▼', 'R', 'e', 's', 'p', 'o', 'n', 's', 'e', nil, nil, nil]
        )
      end
    end

    context 'when screen smaller than stream' do
      let(:cell_count) { 10 }

      it 'inputs overwritten stream' do
        expect(stream.inputs).to eq(
          ['e', 's', 'p', 'o', 'n', 's', 'e', '│', '▼', 'R']
        )
      end
    end
  end

  describe '#branch' do
    let(:cell_count) { 20 }

    before do
      stream.redraw(cell_count:)
    end

    context 'when event tree branches' do
      before do
        # Normal flow is for an event to branch and event pool to return the correct event tree. Instead we branch event tree directly.
        event_tree.branch(event: Fixtures::EventFactory.route_event)
      end

      it 'inputs third event' do
        expect(stream.inputs).to eq(['o', 'u', 't', 'e', 'e', 's', 't', '│', '▼', 'R', 'e', 's', 'p', 'o', 'n', 's', 'e', '│', '▼', 'R'])
      end
    end
  end

  # Remember: Cursors increment at most by one cell per render, so only test the first cell or render multiple times.
  describe '#render' do
    before do
      stream.redraw(cell_count: 20)
    end

    context 'before first render' do
      it 'returns nil' do
        expect(stream.outputs[0]).to eq(nil)
      end
    end

    context 'after 1 delay' do
      it 'returns a character' do
        stream.render(duration: 75)
        expect(stream.outputs[0]).to eq('R')
      end
    end

    context 'after 2 delays' do
      it 'returns 2 characters' do
        stream.render(duration: 75)
        stream.render(duration: 75)

        expect(stream.outputs[0..1]).to eq(%w[R e])
      end
    end

    context 'before 5 seconds' do
      it 'keeps characters' do
        stream = described_class.new(index: 0, config:, event_tree:)
        stream.redraw(cell_count: 20)
        stream.render(duration: 4999)

        expect(stream.outputs[0]).to eq('R')
      end

      context 'with fade' do
        let(:config_overrides) { { fade: true } }

        it 'keeps characters' do
          stream = described_class.new(index: 0, config:, event_tree:)
          stream.redraw(cell_count: 20)
          stream.render(duration: 4999)

          expect(stream.outputs[0]).to eq('R')
        end
      end
    end

    context 'after 10 seconds' do
      it 'keeps characters' do
        stream = described_class.new(index: 0, config:, event_tree:)
        stream.redraw(cell_count: 20)
        stream.render(duration: 10_001)

        expect(stream.outputs[0]).to eq('R')
      end

      context 'with fade' do
        let(:config_overrides) { { fade: true } }

        it 'removes characters' do
          stream = described_class.new(index: 0, config:, event_tree:)
          stream.redraw(cell_count: 20)
          stream.render(duration: 10_001)

          expect(stream.outputs[0]).to eq(nil)
        end
      end
    end
  end
end
