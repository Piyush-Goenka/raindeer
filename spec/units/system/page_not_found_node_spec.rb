# frozen_string_literal: true

require 'observers'
require 'low_loop'
require 'low_node'

require_relative '../../../lib/system/page_not_found_node'
require_relative '../../factories/request_factory'

RSpec.describe PageNotFoundNode do
  subject(:page_not_found) { described_class }

  let(:low_loop) { LowLoop.new }

  before do
    Observers::Observables.reset
    Object.send(:remove_const, 'PageNotFoundNode') unless defined?(PageNotFoundNode)
    load 'lib/system/page_not_found_node.rb'
  end

  context 'when a 404 status event is triggered' do
    let(:event) { Low::Events::StatusEvent.new(status: LowType::Status[404], request:) }
    let(:request) { Low::Support::RequestFactory.request(path: '/missing-page') }

    it 'renders a response' do
      response = low_loop.trigger(LowType::Status[404], action: :render, event:)
      expect(response).to be_instance_of(Low::Events::ResponseEvent)
    end
  end
end
