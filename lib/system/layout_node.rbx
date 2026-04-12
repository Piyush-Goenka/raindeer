# frozen_string_literal: true

class LayoutNode < LowNode
  def render(event:)
    <header>System</header>
    <{ :slot }>
    <footer>Footer</footer>
  end
end
