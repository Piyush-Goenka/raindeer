# frozen_string_literal: true

require 'antlers'

module Rain
  class TOCNode < Antlers::LeafNode
    def initialize(name:)
      super(name:)
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

      def build(**)
        new(name: :toc)
      end
    end
  end
end
