# frozen_string_literal: true

class StatusNode < LowNode
  observe Status

  def initialize(event: StatusEvent)
    @status_code = event.status.status_code
  end

  def render
    <div class="status status-{@status_code}">
      <em>{@status_code}</em>
    </div>
  end
end
