# frozen_string_literal: true

module System
  class DashboardNode < LowNode
    observe '/system'

    def initialize(event:)
      @node_count = LowNode.count
      @event_count = LowEvent.count
    end

    def render(event:) # rubocop:disable Lint/UnusedMethodArgument
      <{ LayoutNode: }>
        <h1>{"Dashboard"}</h1>

        <div class="grid">
          <{ StatFormatter title='Nodes' stat=@node_count }>
          <{ StatFormatter title='Events' stat=@event_count }>
        </div>
      <{ :LayoutNode }>
    end
  end
end
