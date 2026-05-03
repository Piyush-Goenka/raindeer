# frozen_string_literal: true

require 'ostruct'
require 'yaml'

module Rain
  class ConfigLoader
    class << self
      def load(filepath, overrides = {})
        config_file = YAML.safe_load_file(filepath, permitted_classes: [Symbol], symbolize_names: true)

        # Environment variables override config file.
        config_data = config_file.merge(overrides) do |_key, old_value, new_value|
          new_value.nil? ? old_value : new_value
        end

        OpenStruct.new(config_data)
      end

      def parse_boolean(value)
        return true if value == '1'
        return false if value == '0'

        nil
      end
    end
  end
end
