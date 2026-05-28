# frozen_string_literal: true

module Rain
  class Effect
    attr_accessor :last_output

    def initialize(config:)
      @config = config
      @last_output = {}
    end

    def save(output:, x:, y:)
      @last_output[x] ||= {}
      @last_output[x][y] = output
    end
  end
end
