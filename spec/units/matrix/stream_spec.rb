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
    before do
      rain_stream.redraw(cell_count: 20)
    end

    context 'on first frame' do
      it 'returns nil' do
        expect(rain_stream.render(cell_index: 0, duration: 0)).to eq(nil)
      end
    end

    context 'on second frame' do
      it 'returns a character' do
        expect(rain_stream.render(cell_index: 0, duration: 34)).to eq('R')
      end
    end

    context 'on third frame' do
      it 'returns 2 characters' do
        expect(rain_stream.render(cell_index: 0, duration: 34)).to eq('R')
        expect(rain_stream.render(cell_index: 1, duration: 34)).to eq('e')
      end
    end
  end
end
