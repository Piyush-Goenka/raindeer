# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/stream'
require_relative '../../../lib/support/config_loader'
require_relative '../../factories/event_factory'

RSpec.describe Rain::Stream do
  subject(:stream) { described_class.new(index: 0, config:, event_tree:) }

  let(:config) { Rain::ConfigLoader.load('./spec/fixtures/config/matrix.yaml', overrides) }
  let(:overrides) { {} }
  let(:event_tree) { Fixtures::EventFactory.request_response_tree }

  describe '#redraw' do
    context 'when screen larger than stream' do
      let(:cell_count) { 20 }

      it 'returns full stream' do
        expect(stream.redraw(cell_count:)).to eq(
          ["R", "e", "q", "u", "e", "s", "t", "│", "▼", "R", "e", "s", "p", "o", "n", "s", "e", nil, nil, nil]
        )
      end
    end

    context 'when screen smaller than stream' do
      let(:cell_count) { 10 }

      it 'returns overwritten stream' do
        expect(stream.redraw(cell_count:)).to eq(
          ["e", "s", "p", "o", "n", "s", "e", "│", "▼", "R"]
        )
      end
    end
  end

  # Remember: Cursors increment at most by one cell per render, so only test the first cell or render multiple times.
  describe '#render' do
    before do
      stream.redraw(cell_count: 20)
    end

    context 'on first frame' do
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

        expect(stream.outputs[0..1]).to eq(['R', 'e'])
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
        let(:overrides) { { fade: true } }

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
        let(:overrides) { { fade: true } }

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
