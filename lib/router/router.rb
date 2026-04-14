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

    def initialize
      @breadcrumbs = []
      @routes = {}
      @trie = Trie.new
    end

    def route(path, verbs = [], &block)
      @breadcrumbs << path
      path = @breadcrumbs.join

      route = Route.new(path:, verbs: [*verbs])
      @routes[path] = route
      @trie.merge(route:)

      block.call if block_given?

      @breadcrumbs.pop
    end

    def get(path, &block)
      route(path, 'GET', &block)
    end

    def post(path, &block)
      route(path, 'POST', &block)
    end

    def update(path, &block)
      route(path, 'UPDATE', &block)
    end

    def delete(path, &block)
      route(path, 'DELETE', &block)
    end

    # TODO: Define type: ::Low::Events::RequestEvent
    # You can override any route/status simply by adding your own observer.
    def handle(event:)
      response_event = nil

      @trie.match(path: event.request.path.delete_suffix('/')).each do |route_event|
        response_event = trigger route_event.route.path, event: route_event
      end

      if response_event.nil?
        status = Low::Types::Status[404]
        response_event = trigger status, action: :render, event: Low::Events::StatusEvent.new(status:, request: event.request)
      end

      response_event
    end
  end
end

RainRouter = Rain::Router
