# frozen_string_literal: true

class StatFormatter < LowNode
  def render(event:, title:, stat:)
    <article class="stat">
      <div class="number">{stat}</div>
      <footer>{title}</footer>
    </article>
  end
end
