# frozen_string_literal: true

require 'low_dependency'
require 'low_loop'

require_relative 'router/router'

host = ENV.fetch('RAIN_HOST', '127.0.0.1').freeze
port = ENV.fetch('RAIN_PORT', 4133)
matrix_mode = ENV.fetch('RAIN_MATRIX', nil) == '1'
mirror_mode = ENV.fetch('RAIN_MIRROR', nil) == '1'

config = Struct.new(:host, :port, :matrix_mode, :mirror_mode)

LowDependency.provide('rain.router') do
  RainRouter.new
end

LowDependency.provide('low.loop') do
  # TODO: Use "def method(dependency: Dependency)" in low loop's constructor when this feature is ready.
  LowLoop.new(config: config.new(host, port, matrix_mode, mirror_mode), router: Low::Providers['rain.router'])
end

require_relative 'system/system'
