# frozen_string_literal: true

require_relative 'raindown/raindown'

module Rain
  class Pages
    include LowType

    attr_reader :url_paths

    Page = Struct.new(:metadata, :html)

    def initialize(metadata:)
      @url_paths = metadata.url_paths
      @raindown = Raindown.new(metadata:)
    end

    def page(path:)
      path = '/home' if path == '/'
      url_path = File.expand_path("app/pages#{path}", Dir.pwd)
      file_path = @url_paths[url_path] || return

      metadata, markdown = parse_file(file_path:)
      raindown = @raindown.render(markdown:)

      Page.new(metadata, raindown)
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
