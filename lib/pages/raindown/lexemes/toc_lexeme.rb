# frozen_string_literal: true

require 'interfaces/lexeme' # From antlers gem, too generic.

module Rain
  module TOCLexeme
    include Antlers::Lexeme
    extend self

    KEYWORDS = [':toc'].freeze

    def match?(keywords:, **)
      keywords.keys.include?(':toc')
    end

    def lexeme(**)
      { toc: :default }
    end
  end
end
