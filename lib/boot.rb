# frozen_string_literal: true

require 'low_dependency'
require 'low_loop'

require_relative 'router/router'

LowDependency.provide('low.loop') do
  low_loop = LowLoop.new
  low_loop.observable
  low_loop
end

LowDependency.provide('rain.router') do
  RainRouter.new
end

require_relative 'system/system'
