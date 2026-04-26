# frozen_string_literal: true

require 'low_event'
require_relative '../fixtures/mock_events'

module Fixtures
  class EventFactory
    class << self
      def request_response_tree(step: 0)
        event_tree = Low::Events::EventTree.new
        event_tree.branch(event: RequestEvent.new(step:))
        event_tree.branch(event: ResponseEvent.new(step: step == 0 ? step : step + 1))
        event_tree
      end
    end
  end
end
