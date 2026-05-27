# frozen_string_literal: true

class ObserversCount < LowNode
  def render(event:, route:)
    Observers[route].count.to_s
  end
end
