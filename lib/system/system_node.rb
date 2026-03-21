# frozen_string_literal: true

class SystemNode < LowNode
  observe '/system'

  def render(event: Rain::RouteEvent) # rubocop:disable Lint/UnusedMethodArgument
    'SYSTEM!'
  end
end
