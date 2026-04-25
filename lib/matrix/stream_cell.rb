# frozen_string_literal: true

module Rain
  # TODO: Refactor "renderable" to StreamCell.
  class StreamCell
    attr_reader :character, :timestamp

    def initialize(character:, timestamp:)
      @character = character
      @timestamp = timestamp
    end
  end
end
