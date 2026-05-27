# frozen_string_literal: true

class EventsNode < LowNode
  observe '/system/events'

  def initialize(event:)
    @events = LowEvent.events
  end

  def render(event:)
    <{ LayoutNode: }>
      <h1>{"Events"}</h1>

      <table>
        <thead>
          <tr>
            <th scope="col">Event</th>
            <th scope="col">Observers</th>
          </tr>
        </thead>
        <tbody>
          <{ for: event in: @events }>
            <tr>
              <td>{event}</td>
              <td></td>
            </tr>
          <{ :for }>
        </tbody>
      </table>
    <{ :LayoutNode }>
  end
end
