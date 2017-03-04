# Configuring the Transport

Hyperloop implements push notifications (via a number of possible technologies) so changes to records on the server are dynamically pushed to all authorized clients.

The can be accomplished by configuring **one** of the push technologies below:

| Push Technology | When to choose this...        |
|---------------------------|--------------------|
| [Simple Polling](#setting-up-simple-polling) | The easiest push transport is the built-in simple poller.  This is great for demos or trying out Hyperloop but because it is constantly polling it is not suitable for production systems or any kind of real debug or test activities. |
| [Action Cable](#setting-up-action-cable) | If you are using Rails 5 this is the perfect route to go. Action Cable is a production ready transport built into Rails 5. |
| [Pusher.com](#setting-up-pusher-com) | Pusher.com is a commercial push notification service with a free basic offering. The technology works well but does require a connection to the internet at all times. |
| [Pusher Fake](#setting-up-pusher-fake) | The Pusher-Fake gem will provide a transport using the same protocol as pusher.com but you can use it to locally test an app that will be put into production using pusher.com. |

### Setting up Simple Polling

The easiest push transport is the built-in simple poller.  This is great for demos or trying out Hyperloop but because it is constantly polling it is not suitable for production systems or any kind of real debug or test activities.

Simply add this initializer:

```ruby
#config/initializers/hyperloop.rb
Hyperloop.configuration do |config|
  config.transport = :simple_poller
  # options
  # config.opts = {
  #   seconds_between_poll: 5, # default is 0.5 you may need to increase if testing with Selenium
  #   seconds_polled_data_will_be_retained: 1.hour  # clears channel data after this time, default is 5 minutes
  # }
end
```

That's it. Hyperloop will use simple polling for the push transport.

--------------------

### Setting up Action Cable

To configure Hyperloop to use Action Cable, add this initializer:

```ruby
#config/initializers/hyperloop.rb
Hyperloop.configuration do |config|
  config.transport = :action_cable
end
```

If you are already using ActionCable in your app that is fine, as Hyperloop will not interfere with your existing connections.

**Otherwise** go through the following steps to setup ActionCable.

Firstly, make sure the `action_cable` js file is required in your assets.

Typically `app/assets/javascripts/application.js` will finish with a `require_tree .` and this will pull in the `cable.js` file which will pull in `action_cable.js`

However at a minimum if `application.js` simply does a `require action_cable` that will be sufficient for Hyperloop.

Make sure you have a cable.yml file:

```yml
# config/cable.yml
development:
  adapter: async

test:
  adapter: async

production:
  adapter: redis
  url: redis://localhost:6379/1
```

Set allowed request origins (optional):

**By default action cable will only allow connections from localhost:3000 in development.**  If you are going to something other than localhost:3000 you need to add something like this to your config:

```ruby
# config/environments/development.rb
Rails.application.configure do
  config.action_cable.allowed_request_origins = ['http://localhost:3000', 'http://localhost:5000']
end
```

That's it. Hyperloop will use Action Cable as the push transport.

----------------

### Setting up Pusher.com

[Pusher.com](https://pusher.com/) provides a production ready push transport for your App.  You can combine this with [Pusher-Fake](/docs/pusher_faker_quickstart.md) for local testing as well.  You can get a free pusher account and API keys at [https://pusher.com](https://pusher.com)

First add the Pusher and HyperLoop gems to your Rails app:

add `gem 'pusher'` to your Gemfile.

Next Add the pusher js file to your application.js file:

```ruby
# app/assets/javascript/application.js
...
//= require 'hyper-model/pusher'
//= require_tree .
```

Finally set the transport:

```ruby
# config/initializers/Hyperloop.rb
Hyperloop.configuration do |config|
  config.transport = :pusher
  config.channel_prefix = "Hyperloop"
  config.opts = {
    app_id: "2....9",
    key: "f.....g",
    secret: "1.......3"
  }
end
```

That's it. You should be all set for push notifications using Pusher.com.

-------------------------
### Setting up Pusher Fake

The [Pusher-Fake](https://github.com/tristandunn/pusher-fake) gem will provide a transport using the same protocol as pusher.com.  You can use it to locally test an app that will be put into production using pusher.com.

Firstly add the Pusher, Pusher-Fake and HyperLoop gems to your Rails app

- add `gem 'pusher'` to your Gemfile.
- add `gem 'pusher-fake'` to the development and test sections of your Gemfile.

Next add the pusher js file to your application.js file

```ruby
# app/assets/javascript/application.js
...
//= require 'hyper-model/pusher'
//= require_tree .
```

Add this initializer to set the transport:

```ruby
# typically app/config/initializers/Hyperloop.rb
# or you can do a similar setup in your tests (see this gem's specs)
require 'pusher'
require 'pusher-fake'
# Assign any values to the Pusher app_id, key, and secret config values.
# These can be fake values or the real values for your pusher account.
Pusher.app_id = "MY_TEST_ID"      # you use the real or fake values
Pusher.key =    "MY_TEST_KEY"
Pusher.secret = "MY_TEST_SECRET"
# The next line actually starts the pusher-fake server (see the Pusher-Fake readme for details.)
require 'pusher-fake/support/base' # if using pusher with rspec change this to pusher-fake/support/rspec
# now copy over the credentials, and merge with PusherFake's config details
Hyperloop.configuration do |config|
  config.transport = :pusher
  config.channel_prefix = "Hyperloop"
  config.opts = {
    app_id: Pusher.app_id,
    key: Pusher.key,
    secret: Pusher.secret
  }.merge(PusherFake.configuration.web_options)
end
```

That's it. You should be all set for push notifications using Pusher Fake.
