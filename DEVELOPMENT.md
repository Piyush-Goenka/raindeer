# Development

## Setup

In your terminal run:
```shell
bundle install
bin/server
```

ℹ️ In iTerm you may need to press `Option + A` to accept screen refreshing.
ℹ️ In Ghostty the matrix flickers a little but it adds to the effect. Ghostty it's only 10fps!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Debugging

### Debug Mode [UNRELEASED]

Set `RAIN_DEBUG_MODE=1` to switch Raindeer to a non-asynchronous server which well you debug with standard methods such as:
```ruby
p variable
puts variable
binding.pry # Debug mode requires pry for you
```

### Async Mode

`RAIN_ASYNC_MODE=1` is the default. In this async environment we must first block the fiber:
```ruby
Fiber.blocking { binding.irb }
```

https://socketry.github.io/async/guides/debugging/index

## Testing

Run all tests with `bundle exec rspec`.
Add the `SHOW_OUTPUT=1` flag to see the terminal output of some of the feature tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://codeberg.org/raindeer/raindeer.
