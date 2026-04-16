# frozen_string_literal: true

class EventsNode < LowNode
  observe '/system/events'

  def initialize(event:)
    @events = 'TODO: Populate via LowEvent inherited hook.'
  end

  def render(event:)
    <{ LayoutNode: }>
      <h1>{"Events"}</h1>

      {@events}

      <table>
        <thead>
          <tr>
            <th scope="col">HTTP Verbs</th>
            <th scope="col">Route</th>
            <th scope="col">Observers</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td>
            <td>2</td>
            <td>3</td>
          </tr>
        </tbody>
      </table>
    <{ :LayoutNode }>
  end
end
