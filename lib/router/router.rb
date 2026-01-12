# frozen_string_literal: true

require 'low_dependency'
require 'low_event'

require_relative 'route'
require_relative 'route_event'
require_relative 'trie'

module Rain
  class Router
    include LowType
    include Observers

    attr_reader :routes, :trie

    def initialize(low_loop:)
      @breadcrumbs = []
      @routes = {}
      @trie = Trie.new

      observe low_loop
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

    # TODO: Define type: ::Low::Events::RequestEvent
    # You can override any route/status simply by adding your own observer.
    def handle(event:)
      response_event = nil

      @trie.match(path: event.request.path).each do |route_event|
        response_event = trigger route_event.route.path, event: route_event
      end

      if response_event.nil?
        status = LowType::Status[404]
        response_event = trigger status, event: Low::Events::StatusEvent.new(status:, request: event.request)
      end

      response_event
    end
  end
end

RainRouter = Rain::Router
