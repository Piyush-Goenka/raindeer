# frozen_string_literal: true

require 'low_dependency'
require 'low_loop'

require_relative 'router/router'

LowDependency.provide('low.loop') do
  LowLoop.new
end

LowDependency.provide('rain.router') do
  # TODO: Use "def method(dependency: Dependency)" in rain router's constructor when this feature is ready.
  RainRouter.new(low_loop: Low::Providers['low.loop'])
end

require_relative 'system/system'
