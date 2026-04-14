# frozen_string_literal: true

class RoutesNode < LowNode
  observe '/system/routes'

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      <h1>{"Routes"}</h1>
    <{ :LayoutNode }>
  end
end
