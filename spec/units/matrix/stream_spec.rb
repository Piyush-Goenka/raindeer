# frozen_string_literal: true

require 'low_event'

require_relative '../../../lib/matrix/stream'
require_relative '../../factories/event_factory'

RSpec.describe Rain::Stream do
  subject(:rain_stream) { described_class.new(index: 0, event_tree:) }

  let(:event_tree) { Fixtures::EventFactory.request_response_tree }

  describe '#redraw' do
    context 'when screen larger than stream' do
      let(:cell_count) { 20 }

      it 'returns full stream' do
        expect(rain_stream.redraw(cell_count:)).to eq(
          ["R", "e", "q", "u", "e", "s", "t", "│", "▼", "R", "e", "s", "p", "o", "n", "s", "e", nil, nil, nil]
        )
      end
    end

    context 'when screen smaller than stream' do
      let(:cell_count) { 10 }

      it 'returns overwritten stream' do
        expect(rain_stream.redraw(cell_count:)).to eq(
          ["e", "s", "p", "o", "n", "s", "e", "│", "▼", "R"]
        )
      end
    end
  end

  describe '#render' do
  end

  describe '#characters' do
    before do
      rain_stream.redraw(cell_count: 20)
    end

    it 'returns a character' do
      expect(rain_stream.characters[0]).to eq('R')
    end
  end
end
