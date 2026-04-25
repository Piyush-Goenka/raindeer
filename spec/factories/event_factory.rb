# frozen_string_literal: true

require 'low_event'
require_relative '../fixtures/mock_events'

module Fixtures
  class EventFactory
    class << self
      def create_event_tree
        event_tree = Low::Events::EventTree.new
        event = RequestEvent.new
        event_tree.branch(event:)
        event_tree
      end
    end
  end
end
