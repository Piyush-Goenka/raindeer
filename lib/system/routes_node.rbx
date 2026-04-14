# frozen_string_literal: true

class RoutesNode < LowNode
  observe '/system/routes'

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      {"Routes"}
    <{ :LayoutNode }>
  end
end
