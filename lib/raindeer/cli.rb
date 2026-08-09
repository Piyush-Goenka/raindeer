# frozen_string_literal: true

require 'low_node'
require 'low_type'
require 'observers'
require 'providers'

# Allows the CLI to load application code and metadata, but not start a server.

#################################################
# FRAMEWORK INTERNAL API
#################################################

module Rain
  Providers.define('rain.router') do
    require_relative '../router/router'
    Router.new
  end
end

#################################################
# FRAMEWORK EXTERNAL API
#################################################

module Raindeer
  class << self
    def router(&block)
      Providers['rain.router'].instance_eval(&block)
    end
  end
end

#################################################
# CLI
#################################################

require_relative '../cli/cli'
