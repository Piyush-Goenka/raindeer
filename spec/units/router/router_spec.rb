# frozen_string_literal: true

require 'observers'
require 'low_event'

require_relative '../../../lib/router/router'
require_relative '../../factories/request_factory'

RSpec.describe Rain::Router do
  subject(:rain_router) { described_class.new }

  before do
    Observers::Keys.reset
  end

  describe '#route' do
    it 'creates combinatorial routes' do
      rain_router.get '/users' do
        rain_router.get '/:id'
      end

      expect(rain_router.routes['/users']).to have_attributes(path: '/users', verbs: ['GET'])
      expect(rain_router.routes['/users/:id']).to have_attributes(path: '/users/:id', verbs: ['GET'])
    end
  end

  describe '#handle' do
    let(:request_event) { Low::Events::RequestEvent.new(request:) }

    before do
      class MockObserver
        include Observers
        observe '/users'
        observe Low::Types::Status[404]
        def self.render = nil
      end

      allow(MockObserver).to receive(:render)
    end

    context 'when the route is found' do
      let(:request) { Low::Support::RequestFactory.request(path: '/users') }

      before do
        rain_router.get '/users'
      end

      it 'triggers route event on observer' do
        rain_router.handle(event: request_event)
        expect(MockObserver).to have_received(:render).with({ event: an_instance_of(Rain::RouteEvent) })
      end
    end

    context 'when the route is missing' do
      let(:request) { Low::Support::RequestFactory.request(path: '/missing-path') }

      it 'triggers status event on observer' do
        rain_router.handle(event: request_event)
        expect(MockObserver).to have_received(:render).with({ event: an_instance_of(Low::Events::StatusEvent) })
      end
    end
  end
end
