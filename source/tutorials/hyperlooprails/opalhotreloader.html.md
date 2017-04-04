##### <i class="flaticon-professor-teaching"></i> <span class="bigfirstletter">O</span>pal Hot Reloader Tutorial


TODO

Before we go any further, let's install two fantastic tools written by Forrest Chang:

+ [Opal Hot Reloader](https://github.com/fkchang/opal-hot-reloader)
+ [Opal Console](https://github.com/fkchang/opal-console)

Opal Hot Reloader is for pure programmer joy (not having to reload the page to compile your source) and the Opal Console is incredibly useful to test how Ruby code compiles to JavaScript.

We are also going to add the Foreman gem to run our Rails server and the Hot Reloader service for us.

Add the following lines to your `gemfile` and run `bundle`:

```ruby
#gemfile

gem 'opal_hot_reloader', git: 'https://github.com/fkchang/opal-hot-reloader.git'
gem 'foreman'
```

`bundle install`

Modify your `hyperloop.rb`, adding the following lines inside the if statement so they only run on the client and not as part of the server pre-rendering process:

```ruby
#app/hyperloop/hyperloop.rb

if React::IsomorphicHelpers.on_opal_client?
  ...
  require 'opal_hot_reloader'
  OpalHotReloader.listen(25222, true)
end
```

Then create a `Procfile` in your Rails app root so the Hot Reloader service will start whenever you start your server:

```text
#Procfile

rails: bundle exec rails server -p 3000
hotloader: opal-hot-reloader -p 25222 -d app/hyperloop/components
```

To start both servers:

`bundle exec foreman start`

Refresh your browser and edit your `planeventslist.rb`:
```ruby
ReactBootstrap::Button(bsStyle: :primary) do
  "New Event"
end.on(:click) { save_new_planevent }
```
Save and you should see the button text change magically in your browser without having to refresh. Pure joy.  