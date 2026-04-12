# frozen_string_literal: true

class PageNotFoundNode < LowNode
  observe Status[404]

  def render(event: Low::Events::StatusEvent) # rubocop:disable Lint/UnusedMethodArgument
    <{ LayoutNode: }>
      <div class="page-not-found">
        <em>404</em>
      </div>
    <{ :LayoutNode }>
  end
end
