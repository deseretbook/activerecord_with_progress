# ActiverecordWithProgress

Similar to other gems that provide progress bars for `Enumerable`, this gem
provides a progress bar for ActiveRecord relations.  We use it for Rake tasks,
migrations, and console commands.  Maybe it's useful to you, too.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_with_progress', github: 'deseretbook/activerecord_with_progress'
```

And then execute:

    $ bundle


## Usage

Provides `_with_progress` wrappers (via `method_missing`) for several common
ActiveRecord iteration methods.  They should have, but are not guaranteed to
have, the same memory usage, computation requirements, and access patterns as
the methods they wrap.


```ruby
SomeModel.all.each_with_progress do |record|
  # Do something with the record
end

SomeModel.all.find_each_with_progress do |record|
  # ...
end

SomeModel.all.each_with_index_and_progress do |record, index|
  # ...
end

SomeModel.where(condition: true).each_with_index_and_progress do |record, index|
  # ...
end

mapped = SomeModel.all.map_with_progress do |record|
  # ...
end
```

There's an option to catch errors and return them in a second return value:

```ruby
# Returns the #each return value, and a Hash mapping failed records to exceptions
_, errors = SomeModel.all.each_with_progress(handle_errors: true) do |record|
  raise 'Handled'
end

# Returns the map with nil for errors, and a Hash with exceptions.
mapped, errors = SomeModel.where(some: 'condition').map_with_progress(handle_errors: true) do |record|
  raise 'Nil in the map'
end
```

The `find_in_batches` method is a little bit tricker to work with:

```ruby
# Need to override :total; I would use #find_each_with_progress instead.
query = SomeModel.where(query: 'parameters')
query.find_in_batches_with_progress(batch_size: 5, total: query.count / 5 + !) do |batch| puts batch.size end
```


You can change the progress bar format from the colorful default.  See the docs
for [ruby-progressbar](https://rubygems.org/gems/ruby-progressbar) for format
details.

```ruby
ActiverecordWithProgress.progress_format = 'a ruby-progressbar format string'
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deseretbook/activerecord_with_progress.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

This independent gem is not an official part of or endorsed add-on for ActiveRecord.
