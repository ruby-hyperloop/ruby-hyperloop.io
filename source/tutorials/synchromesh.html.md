## Synchromesh

[The source code to this tutorial is here](https://github.com/barriehadfield/reactrb-showcase)

Reactive Record is the data layer between one client and its server and Synchromesh uses push notifications to push changed records to all connected Reactive Record clients.

Synchromesh is incredibly simple to setup. Add this line to your Gemfile:

```ruby
gem 'synchromesh', git: "https://github.com/reactrb/synchromesh.git"
```

And then execute:

``` text
$ bundle install
```

Next add this line to your `components.rb`:

```ruby
require 'synchromesh'
```

Finally, you need to add an initialiser `config/initializers/synchromesh.rb`

```ruby
# config/initializers/synchromesh.rb
Synchromesh.configuration do |config|
  # this is the initialiser for polling, see the synchromesh
  # documentation for using pusher.com
  config.transport = :simple_poller
  config.channel_prefix = "synchromesh"
  config.opts = {
    seconds_between_poll: 1.second,
    seconds_polled_data_will_be_retained: 1.hour
  }
end
```

Restart your server, open two browser windows and be amazed to see any new posts added to one session magically appearing in the other!
