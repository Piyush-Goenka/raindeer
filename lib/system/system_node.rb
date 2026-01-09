# frozen_string_literal: true

class SystemNode < LowNode
  observe '/system'

  def render(event: RouteEvent)
    'SYSTEM!'
  end
end
