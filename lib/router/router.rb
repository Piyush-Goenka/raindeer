# frozen_string_literal: true

require_relative 'route'
require_relative 'route_event'
require_relative 'trie'

module Rain
  class Router
    include LowType
    include Observers

    attr_reader :routes, :trie

    def initialize
      @breadcrumbs = []
      @routes = {}
      @trie = Trie.new

      # TODO: Actually inject dependency.
      observe Low::Providers.find('low.loop').result
    end

    def route(path, verbs = [], &block)
      @breadcrumbs << path
      path = @breadcrumbs.join

      route = Route.new(path:, verbs: [*verbs])
      @routes[path] = route
      @trie.merge(route:)

      observable path

      block.call if block_given?

      @breadcrumbs.pop
    end

    def get(path = String, &block)
      route(path, 'GET', &block)
    end

    def post(path = String, &block)
      route(path, 'POST', &block)
    end

    def update(path = String, &block)
      route(path, 'UPDATE', &block)
    end

    def delete(path = String, &block)
      route(path, 'DELETE', &block)
    end

    # Raindeer internal API.

    # TODO: Define type: ::Low::Events::RequestEvent
    def handle(event:)
      response_event = nil

      # TODO: An application should be able to listen to the same event and override it.
      @trie.match(path: event.request.path).each do |route_event|
        response_event = take(route_event, route_event.route.path)
      end

      response_event unless response_event.nil?
    end
  end
end

RainRouter = Rain::Router
