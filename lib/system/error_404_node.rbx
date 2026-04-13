# frozen_string_literal: true

class Error404Node < LowNode
  observe Low::Types::Status[404]

  def render(event:) # rubocop:disable Lint/UnusedMethodArgument
    <div class="page-not-found">
      <em>404</em>
    </div>
  end
end
