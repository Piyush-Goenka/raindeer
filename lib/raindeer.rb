# frozen_string_literal: true

require 'low_dependency'
require 'low_event'
require 'low_node'
require 'low_type'
require 'observers'

require_relative 'router/router'

class Raindeer
  class << self
    def router(&block)
      Low::Providers.find('rain.router').result.instance_eval(&block)
    end
  end
end
