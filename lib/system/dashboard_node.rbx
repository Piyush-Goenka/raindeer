# frozen_string_literal: true

class DashboardNode < LowNode
  observe '/system'

  def initialize(event:)
    @node_count = LowNode.count
    @event_count = LowEvent.count
    @observer_count = Observers::Keys.keys.keys.reduce(0) do |accum, key|
      accum += Observers[key].count
    end
  end

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      <h1>{"Dashboard"}</h1>

      <div class="grid">
        <{ StatFormatter title='Nodes' stat=@node_count }>
        <{ StatFormatter title='Events' stat=@event_count }>
        <{ StatFormatter title='Observers' stat=@observer_count }>
      </div>
    <{ :LayoutNode }>
  end
end
