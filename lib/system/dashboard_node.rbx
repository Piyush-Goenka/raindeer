# frozen_string_literal: true

class DashboardNode < LowNode
  observe '/system'

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      <h1>{"Dashboard"}</h1>
    <{ :LayoutNode }>
  end
end
