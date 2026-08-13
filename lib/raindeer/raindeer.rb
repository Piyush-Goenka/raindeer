# frozen_string_literal: true

require_relative 'boot'

module Raindeer
  class << self
    def router(&block)
      Providers['rain.router'].instance_eval(&block)
    end

    def pages
      Providers['rain.pages']
    end
  end
end
