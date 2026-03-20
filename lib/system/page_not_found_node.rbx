# frozen_string_literal: true

class PageNotFoundNode < LowNode
  observe Status[404]

  def render(event: Low::Events::StatusEvent) # rubocop:disable Lint/UnusedMethodArgument
    <div class="page-not-found">
      <em>404</em>
    </div>
  end
end
