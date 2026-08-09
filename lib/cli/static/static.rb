# frozen_string_literal: true

require 'antlers'
require 'lowload'

module Rain
  module CLI
    module Static
      extend self

      def build(application_path:)
        metadata = LowLoad.dirload(File.expand_path('app', application_path))
        # TODO: Use metadata.url_paths to HTTP Request and export the response to a build folder of HTML.
      end
    end
  end
end
