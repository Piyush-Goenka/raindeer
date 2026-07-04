# frozen_string_literal: true

require 'low_event'
require 'low_node'
require 'low_type'
require 'observers'
require 'providers'

require_relative '../pages/pages'
require_relative '../router/router'
require_relative '../support/config_loader'

#################################################
# INTERNAL API
#################################################

module Rain
  env = {
    host: ENV.fetch('RAIN_HOST', nil),
    port: ENV.fetch('RAIN_PORT', nil),
    web_root: ENV.fetch('RAIN_WEB_ROOT', nil),
    debug_mode: ConfigLoader.parse_boolean(ENV.fetch('RAIN_DEBUG', true)),
    matrix_mode: ConfigLoader.parse_boolean(ENV.fetch('RAIN_MATRIX', nil)),
    mirror_mode: ConfigLoader.parse_boolean(ENV.fetch('RAIN_MIRROR', nil))
  }

  config = ConfigLoader.load('config.yaml', env)

  Providers.define('rain.router') do
    require_relative '../router/router'
    Router.new
  end

  Providers.define('rain.matrix') do
    require_relative '../matrix/matrix'
    Matrix.new(event_pool: Providers['low.event.pool'])
  end

  Providers.define('low.loop') do
    require 'low_loop'
    LowLoop.new(config:, router: Providers['rain.router'], renderer: Providers['rain.matrix'])
  end
end

#################################################
# EXTERNAL API
#################################################

module Raindeer
  class << self
    def router(&block)
      Providers['rain.router'].instance_eval(&block)
    end
  end
end

#################################################
# USER CODE
#################################################

require 'antlers' # LowLoad supports antlers but doesn't make it a hard dependency.
require 'lowload'
LowLoad.dirload(File.expand_path('../system', __dir__))

application_path = File.expand_path('app', Dir.pwd)
return unless Dir.exist?(application_path)

metadata = LowLoad.dirload(application_path)
return unless Dir.exist?(File.expand_path('pages', application_path))

Providers.define('rain.pages', eager: true) do
  Rain::Pages.new(url_paths: metadata.url_paths)
end
