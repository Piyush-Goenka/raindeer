# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in raindeer.gemspec
gemspec

group :development do
  gem 'low_event', path: '../low_event'
  gem 'low_loop', path: '../low_loop'
  gem 'low_node', path: '../low_node'
  gem 'low_type', path: '../low_type'
  gem 'lowkey', path: '../lowkey'
  gem 'lowload', path: '../lowload'

  gem 'antlers', path: '../antlers'
  gem 'expressions', path: '../expressions'
  gem 'observers', path: '../observers'
  gem 'providers', path: '../providers'

  gem 'irb'
  gem 'rake', '~> 13.0'
  gem 'rubocop', require: false
end

group :testing do
  gem 'protocol-http'
  gem 'rspec', '~> 3.0'
  gem 'timecop'
end
