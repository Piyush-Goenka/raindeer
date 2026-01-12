# frozen_string_literal: true

require_relative 'page_not_found_node'

class SystemNode < LowNode
  observe '/system'

  def render(event: RouteEvent)
    'SYSTEM!'
  end
end
