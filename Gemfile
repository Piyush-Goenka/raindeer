# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in raindeer.gemspec
gemspec

group :development do
  local_gems = {
    'low_event' => '../low_event',
    'lowkey' => '../lowkey',
    'lowload' => '../lowload',
    'low_loop' => '../low_loop',
    'low_node' => '../low_node',
    'low_type' => '../low_type',

    'antlers' => '../antlers',
    'expressions' => '../expressions',
    'observers' => '../observers',
    'providers' => '../providers',
  }

  local_gems.each do |name, relative_path|
    path = File.expand_path(relative_path, __dir__)

    if File.exist?(path)
      gem name, path:
    else
      gem name
    end
  end

  gem 'irb'
  gem 'rake', '~> 13.0'
  gem 'rubocop', require: false
end

group :testing do
  gem 'protocol-http'
  gem 'rspec', '~> 3.0'
  gem 'timecop'
end
