# frozen_string_literal: true

if ENV.fetch('RAIN_ENV', nil) == 'dev'
  require 'pry'
  require 'pry-nav'
  require_relative '../../low_dependency/lib/low_dependency'
  require_relative '../../low_event/lib/low_event'
  require_relative '../../low_loop/lib/low_loop'
  require_relative '../../lownode/lib/low_node'
  require_relative '../../lowtype/lib/low_type'
  require_relative '../../lowload/lib/lowload'
  require_relative '../../observers/lib/observers'
else
  require 'low_dependency'
  require 'low_event'
  require 'low_loop'
  require 'low_node'
  require 'low_type'
  require 'lowload'
end

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

LowLoad.dirload(File.expand_path('../system', __FILE__))
