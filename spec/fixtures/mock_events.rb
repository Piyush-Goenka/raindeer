# frozen_string_literal: true

module Fixtures
  class MockEvent
    attr_reader :created_at
    attr_accessor :children

    def initialize(created_at: nil, step: 0)
      @created_at = (created_at || Time.now.to_i) + step
      @children = []
    end
  end

  class RequestEvent < MockEvent; end
  class RouteEvent < MockEvent; end
  class RenderEvent < MockEvent; end
  class ResponseEvent < MockEvent; end
end
