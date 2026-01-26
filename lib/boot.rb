# frozen_string_literal: true

require 'low_loop'
require 'low_dependency'

require_relative 'support/config_loader'

env = {
  host: ENV.fetch('RAIN_HOST', nil),
  port: ENV.fetch('RAIN_PORT', nil),
  web_root: ENV.fetch('RAIN_WEB_ROOT', nil),
  matrix_mode: Rain::ConfigLoader.parse_boolean(ENV.fetch('RAIN_MATRIX', nil)),
  mirror_mode: Rain::ConfigLoader.parse_boolean(ENV.fetch('RAIN_MIRROR', nil))
}

config = Rain::ConfigLoader.load('./config/config.yaml', env)

LowDependency.provide('rain.router') do
  RainRouter.new
end

LowDependency.provide('low.loop') do
  LowLoop.new(config:, router: Low::Providers['rain.router'])
end

require_relative 'system/system'
