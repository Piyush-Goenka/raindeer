# frozen_string_literal: true

require_relative '../raindeer'

Raindeer.router do
  get '/system' do
    get '/events'
    get '/routes'
  end
end
