require 'trees'

module Rain
  module CLI
    extend Trees

    line('static') do
      summary { 'Static site generation' }

      line('build') do
        execute { puts 'yes' }
      end
    end
  end
end
