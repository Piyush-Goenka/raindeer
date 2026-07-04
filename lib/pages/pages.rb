# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'

module Rain
  class Pages
    include LowType

    attr_reader :url_paths

    def initialize(url_paths:)
      @url_paths = url_paths
    end

    def render(file_path:)
      text = File.read(file_path).sub(/\A---\s*[\r\n]+.*?\s*[\r\n]+---\s*[\r\n]+/m, '')
      Kramdown::Document.new(text, input: 'GFM').to_html
    end
  end
end
