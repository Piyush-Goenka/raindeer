# frozen_string_literal: true

class RoutesNode < LowNode
  observe '/system/routes'

  def initialize(event:)
    @routes = Providers['rain.router'].routes
  end

  def render(event:)
    <{ LayoutNode: }>
      <h1>{"Routes"}</h1>

      {@routes}

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
