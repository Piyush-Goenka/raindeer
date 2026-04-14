# frozen_string_literal: true

class LayoutNode < LowNode
  def render(event:)
    <html>
      <head>
        <link rel="stylesheet" href="/assets/pico.min.css">
      </head>
      <body>
        <header class="container">
          <img class="favicon" src="/assets/favicon.svg"/>
          <div class="site-title">{"System"}</div>

          <nav id="navbar">
            <ul>
              <li><a href="/system">{"Dashboard"}</a>
              <li><a href="/system/routes">{"Routes"}</a>
            </ul>
          </nav>
        </header>

        <main class="container">
          <{ :slot }>
        </main>

        <footer class="container">
          <ul>
            <li><a href="https://raindeer.dev">{"Website"}</a></li>
            <li><a href="https://raindeer.dev/docs">{"Docs"}</a></li>
            <li><a href="https://github.com/raindeer-rb/raindeer">{"Source code"}</a></li>
          </ul>
        </footer>
      </body>
    </html>
  end
end
