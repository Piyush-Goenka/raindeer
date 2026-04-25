# frozen_string_literal: true

require 'low_event'
require '../fixtures/mock_events'

module Low
  module Fixtures
    class EventFactory
      class << self
        def create_event_tree
          event_tree = EventTree.new
          event = RequestEvent.new(request: 'mock request')
          event_tree.children << event
          event_tree
        end
      end
    end
  end
end
