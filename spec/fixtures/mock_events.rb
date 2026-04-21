# frozen_string_literal: true

module Fixtures
  class MockEvent
    def initialize
      @created_at = Time.now.to_i
    end
  end

  class RequestEvent < MockEvent; end
  class RouteEvent < MockEvent; end
  class RenderEvent < MockEvent; end
  class ResponseEvent < MockEvent; end
end
