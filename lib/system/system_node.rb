# frozen_string_literal: true

class SystemNode < LowNode
  observe '/system'

  def render(event: RouteEvent) # rubocop:disable Lint/UnusedMethodArgument
    'SYSTEM!'
  end
end
