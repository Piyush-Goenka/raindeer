# frozen_string_literal: true

require 'low_event'
require 'low_node'

class SystemNode < LowNode
  observe '/system'

  def render(event: RouteEvent)
    'SYSTEM!'
  end
end
