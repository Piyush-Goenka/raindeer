# frozen_string_literal: true

require 'observers'
require 'low_event'

require_relative '../../../lib/router/router'
require_relative '../../factories/request_factory'

RSpec.describe RainRouter do
  subject(:rain_router) { described_class.new }

  before do
    Observers::Observables.reset
  end

  describe '#route' do
    it 'creates combinatorial routes' do
      rain_router.route '/users' do
        rain_router.get '/:id'
      end

      expect(rain_router.routes['/users']).to have_attributes(path: '/users', verbs: [])
      expect(rain_router.routes['/users/:id']).to have_attributes(path: '/users/:id', verbs: ['GET'])
    end
  end

  describe '#handle' do
    let(:request_event) { Low::Events::RequestEvent.new(request:) }

    context 'when the route is found' do
      let(:request) { Low::Support::RequestFactory.request(path: '/users') }

      before do
        rain_router.get '/users'
        allow(rain_router).to receive(:trigger)
      end

      it 'triggers route event on observers' do
        rain_router.handle(event: request_event)
        expect(rain_router).to have_received(:trigger).with('/users', event: an_instance_of(Rain::RouteEvent))
      end
    end

    context 'when the route is missing' do
      let(:request) { Low::Support::RequestFactory.request(path: '/missing-path') }

      before do
        allow(rain_router).to receive(:trigger)
      end

      it 'triggers status event on observers' do
        rain_router.handle(event: request_event)
        expect(rain_router).to have_received(:trigger).with(Low::Types::Status[404], action: :render, event: an_instance_of(Low::Events::StatusEvent))
      end
    end
  end
end
