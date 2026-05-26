# frozen_string_literal: true

require 'observers'
require 'low_node'
require 'lowload'

LowLoad.lowload(File.join(Dir.pwd, '/lib/system/status_404_node.rbx'))
LowLoad.lowload(File.join(Dir.pwd, '/lib/system/layout_node.rbx'))

require_relative '../../factories/request_factory'
require_relative '../../fixtures/mock_router'

RSpec.describe Status404Node do
  subject(:page_not_found) { described_class }

  let(:mock_router) { MockRouter.new }

  before do
    Observers::Keys.reset
    Object.send(:remove_const, 'Status404Node') unless defined?(Status404Node)
    LowLoad.lowload(File.join(Dir.pwd, '/lib/system/status_404_node.rbx'))
  end

  context 'when a 404 status event is triggered' do
    let(:event) { Low::Events::StatusEvent.new(status: Low::Types::Status[404], request:) }
    let(:request) { Low::Support::RequestFactory.request(path: '/missing-path') }

    it 'renders a response' do
      response = mock_router.take(key: Low::Types::Status[404], action: :render, event:)
      expect(response).to be_instance_of(Low::Events::ResponseEvent)
    end
  end
end
