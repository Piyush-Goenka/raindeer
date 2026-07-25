# frozen_string_literal: true

require 'antlers/elements'
require_relative 'elements'

module Rain
  class Raindown
    def initialize(metadata: {})
      @metadata = metadata
    end

    def render(template:)
      return template unless template.include?('<{') || template.include?('{')

      ast = Antlers.ast(template:, elements: Antlers::Elements[:html, :prop, :var] + Rain::Elements[:toc])

      Antlers.render(ast:, current_binding: binding)
    end
  end
end
