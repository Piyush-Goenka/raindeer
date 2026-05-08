# frozen_string_literal: true

require 'low_event'
require 'low_node'
require 'low_type'
require 'providers'

require_relative 'support/config_loader'

env = {
  host: ENV.fetch('RAIN_HOST', nil),
  port: ENV.fetch('RAIN_PORT', nil),
  web_root: ENV.fetch('RAIN_WEB_ROOT', nil),
  matrix_mode: Rain::ConfigLoader.parse_boolean(ENV.fetch('RAIN_MATRIX', nil)),
  mirror_mode: Rain::ConfigLoader.parse_boolean(ENV.fetch('RAIN_MIRROR', nil))
}

config = Rain::ConfigLoader.load('./config/config.yaml', env)

Providers.define('rain.router') do
  require_relative 'router/router'
  Rain::Router.new
end

Providers.define('rain.matrix') do
  require_relative 'matrix/matrix'
  Rain::Matrix.new(event_pool: Providers['low.event.pool'])
end

Providers.define('low.loop') do
  require 'low_loop'
  LowLoop.new(config:, router: Providers['rain.router'], renderer: Providers['rain.matrix'])
end

require 'lowload'
LowLoad.dirload(File.expand_path('../system', __FILE__))
