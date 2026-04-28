# frozen_string_literal: true

require 'low_event'
require_relative '../fixtures/mock_events'

module Fixtures
  class EventFactory
    class << self
      def request_response_tree(created_at: nil, step: 0)
        event_tree = Low::Events::EventTree.new
        event_tree.branch(event: RequestEvent.new(created_at:, step:))
        event_tree.branch(event: ResponseEvent.new(created_at:, step: step == 0 ? step : step + 1))
        event_tree
      end
    end
  end
end
