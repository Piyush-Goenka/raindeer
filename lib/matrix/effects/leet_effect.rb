# frozen_string_literal: true

require_relative 'effect'

module Rain
  class LeetEffect < Effect
    def initialize(config:)
      super(config:)

      @leet_numbers = @config.leet_keys.transform_keys(&:to_s)
      @leet_letters = @leet_numbers.invert
    end

    def render(output:, next_output:, x:, y:)
      output = filter(output:, next_output:, x:, y:)
      save(output:, x:, y:)
    end

    private

    def filter(output:, next_output:, x:, y:)
      return unless output

      character = output.downcase
      last_character = @last_output.dig(x, y)

      return @leet_numbers[character] if @leet_letters.key?(last_character) && rand < 0.75
      return @leet_numbers[character] if @leet_numbers.key?(character) && rand < 0.005
        
      output
    end
  end
end
