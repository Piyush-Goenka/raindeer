# frozen_string_literal: true

require 'low_type'
require 'low_dependency'
require_relative 'router'

class Raindeer
  class << self
    def router(&block)
      Low::Providers.find('rain.router').result.instance_eval(&block)
    end
  end
end
