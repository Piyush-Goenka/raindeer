# frozen_string_literal: true

require 'low_event'
require 'low_loop'
require 'low_node'
require 'low_type'
require 'lowload'
require 'providers'

require_relative 'matrix/matrix'
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
  Rain::Router.new
end

Providers.define('rain.matrix') do
  Rain::Matrix.new(event_pool: Providers['low.event.pool'])
end

Providers.define('low.loop') do
  LowLoop.new(config:, router: Providers['rain.router'], renderer: Providers['rain.matrix'])
end

LowLoad.dirload(File.expand_path('../system', __FILE__))
