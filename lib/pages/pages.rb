# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'
require 'rouge'

require_relative 'raindown/raindown'

module Rain
  class Pages
    include LowType

    attr_reader :url_paths

    Result = Struct.new(:metadata, :html)

    def initialize(metadata:)
      @url_paths = metadata.url_paths
      @raindown = Raindown.new(metadata:)
    end

    def process(file_path:)
      metadata, markdown = parse_file(file_path:)
      template = Kramdown::Document.new(markdown, input: 'GFM', syntax_highlighter: 'rouge').to_html
      template = template.gsub('&lt;{', '<{').gsub('}&gt;', '}>')
      raindown = @raindown.render(template:)

      Result.new(metadata, raindown)
    end

    private

    def parse_file(file_path:)
      dash_lines = []
      data_lines = []
      text_lines = []

      File.foreach(file_path).with_index do |line, index|
        if line.strip == '---' && dash_lines.count < 2
          dash_lines << line
          next
        elsif dash_lines.count > 0 && dash_lines.count < 2
          data_lines << line
          next
        end

        text_lines << line
      end

      [YAML.safe_load(data_lines.join, symbolize_names: true), text_lines.join.strip]
    end
  end
end
