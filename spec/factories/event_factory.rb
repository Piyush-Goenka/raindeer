# frozen_string_literal: true

require 'low_event'
require_relative '../fixtures/mock_events'

module Fixtures
  class EventFactory
    class << self
      def request_response_tree
        event_tree = Low::Events::EventTree.new
        event_tree.branch(event: RequestEvent.new)
        event_tree.branch(event: ResponseEvent.new)
        event_tree
      end
    end
  end
end
