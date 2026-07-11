# frozen_string_literal: true

require 'plugs'

module Rain
  class Elements
    include Plugs

    plug(:toc) do
      plug(:lexeme) do
        require_relative 'lexemes/toc_lexeme'
        TOCLexeme
      end

      plug(:node) do
        require_relative 'nodes/toc_node'
        TOCNode
      end
    end
  end
end
