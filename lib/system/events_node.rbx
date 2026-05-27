# frozen_string_literal: true

class EventsNode < LowNode
  observe '/system/events'

  def initialize(event:)
    # TODO: Include types that can be observed keys too like Status and Status[404].
    @event_types = LowEvent.events
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
          <{ for: observer_key in: @event_types }>
            <tr>
              <td>{observer_key}</td>
              <td>
                <{ ObserversFormatter observer_key=observer_key }>
              </td>
            </tr>
          <{ :for }>
        </tbody>
      </table>
    <{ :LayoutNode }>
  end
end
