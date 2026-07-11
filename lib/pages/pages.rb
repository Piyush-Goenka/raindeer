# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'
require 'rouge'

module Rain
  class Pages
    include LowType

    attr_reader :url_paths

    def initialize(url_paths:)
      @url_paths = url_paths
    end

    def render(file_path:)
      text = File.read(file_path).sub(/\A---\s*[\r\n]+.*?\s*[\r\n]+---\s*[\r\n]+/m, '')
      html = Kramdown::Document.new(text, input: 'GFM', syntax_highlighter: 'rouge').to_html
    end
  end
end
