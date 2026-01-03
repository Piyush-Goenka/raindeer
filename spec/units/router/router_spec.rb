# frozen_string_literal: true

require 'observers'
require 'low_event' # TODO: Move RequestEvent to LowLoop.
require_relative '../../../lib/router/router'
require_relative '../../factories/request_factory'

RSpec.describe RainRouter do
  subject(:rain_router) { described_class.new }

  before do
    Observers::Observables.reset
  end

  describe '#route' do
    it 'defines routes as observable' do
      rain_router.get '/user'
      expect(Observers::Observables.all.count).to eq(1)
    end

    it 'creates combinatorial routes' do
      rain_router.route '/users' do
        rain_router.get '/:id'
      end

      expect(rain_router.routes['/users']).to have_attributes(path: '/users', verbs: [])
      expect(rain_router.routes['/users/:id']).to have_attributes(path: '/users/:id', verbs: ['GET'])
    end
  end

  describe '#handle' do
    let(:request_event) { Low::RequestEvent.new(request:) }
    let(:request) { Low::RequestFactory.request(path: '/users') }

    before do
      rain_router.get '/users'
    end

    it 'triggers a route event on observers' do
      rain_router.handle(event: request_event)
    end
  end
end
