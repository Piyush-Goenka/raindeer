# frozen_string_literal: true

require 'antlers'

module Rain
  class TOCNode < Antlers::LeafNode
    def initialize(name:, template:)
      super(name:)

      @template = template
    end

    def render(current_binding: nil, parent_binding: nil, slot_node: nil)
      output = "<div id=\"toc\">\n"
      output += "</div>\n"
      output
    end

    class << self
      def match?(segment:)
        segment[:toc]
      end

      def build(template:, **)
        new(name: :toc, template:)
      end
    end
  end
end
