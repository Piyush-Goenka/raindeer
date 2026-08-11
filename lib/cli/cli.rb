# frozen_string_literal: true

require 'trees'
require_relative 'static/static'

module Rain
  module CLI
    extend Trees

    line('new :app_name') do |app_name|
      execute { 'TODO' }
    end

    line('server') do
      execute { system('bin/server') }
    end

    line('build') do
      summary { 'Exports your static site at "app/pages" to the "build" folder.' }
      execute { Static.build(application_path: Dir.pwd) }
    end
  end
end
