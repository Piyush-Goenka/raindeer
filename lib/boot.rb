# frozen_string_literal: true

require 'low_dependency'
require 'low_loop'

require_relative 'router/router'

LowDependency.provide('low.loop') do
  LowLoop.new
end

LowDependency.provide('rain.router') do
  RainRouter.new
end
