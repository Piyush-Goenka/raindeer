require 'trees'

module Rain
  module CLI
    extend Trees

    line('new :app_name') do |app_name|
      execute { 'TODO' }
    end

    line('server') do
      execute { system('bin/server') }
    end

    line('static') do
      summary { 'Static site generation' }

      line('build') do
        execute { puts 'yes' }
      end
    end
  end
end
