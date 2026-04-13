# frozen_string_literal: true

class DashboardNode < LowNode
  observe '/system', action: :render

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      {"Dashboard"}
    <{ :LayoutNode }>
  end
end
