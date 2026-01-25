# frozen_string_literal: true

class PageNotFoundNode < LowNode
  observe Status[404]

  def render(event: StatusEvent) # rubocop:disable Lint/UnusedMethodArgument
    <<~HTML
      <div class="page-not-found">
        <em>404</em>
      </div>
    HTML
  end
end
