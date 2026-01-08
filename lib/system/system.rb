# frozen_string_literal: true

require_relative '../raindeer'
require_relative 'system_node'

Raindeer.router do
  get '/system'
end
