## <i class="flaticon-professor-teaching"></i> <span class="bigfirstletter">O</span>pal Hot Reloader Tutorial

In this tutorial we are going to install a fantastic tool written by Forrest Chang:

+ [Opal Hot Reloader](https://github.com/fkchang/opal-hot-reloader)
+ [Opal Console](https://github.com/fkchang/opal-console)

Opal Hot Reloader is for pure programmer joy (not having to reload the page to compile your source) and the Opal Console is incredibly useful to test how Ruby code compiles to JavaScript.

Opal Hot Reloader is going to just dynamically (via a websocket connection) chunks of code in the page almost instaneously.

We are also going to add the Foreman gem to run our Rails server and the Hot Reloader service for us.

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further.

Then in order to test or `Opal Hot Reloader` Gem, you need to have at least a basic **Hyperloop** appliction. For that you can follow the simple Tutorial: [HelloWorld Tutorial](/tutorials/hyperlooprails/helloworld).

##### Step 1: Updating Gemfile

Add the following lines to your `gemfile` and run `bundle`:

```ruby
#gemfile

gem 'opal_hot_reloader', git: 'https://github.com/fkchang/opal-hot-reloader.git'
gem 'foreman'
```

`bundle install`

##### Step 2: Configuring your application

Modify your `hyperloop.rb` initializer, adding the following lines inside the if statement so they only run on the client and not as part of the server pre-rendering process:

```ruby
#config/initializers/hyperloop.rb

Hyperloop.configuration do |config|

  config.transport = :simple_poller
  
  config.import 'opal_hot_reloader'
 
end
```

##### Step 3: Creating the Procfile

Then create a `Procfile` in your Rails app root so the Hot Reloader service will start whenever you start your server:

```text
#Procfile

rails: bundle exec rails server -p 3000
hotloader: opal-hot-reloader -p 25222 -d app/hyperloop/components
```

##### Step 4: Running the application

To start both servers:

`bundle exec foreman start`


##### Step 5: Playing 

Refresh your browser and edit a Hyperloop Component, for example `helloworld.rb`:

```ruby
class Helloworld < Hyperloop::Component

  state show_field: false
  state field_value: ""

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      show_input
      H1 { "#{state.field_value}" }
    end if state.show_field
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
    end.on(:click) { mutate.show_field !state.show_field }
  end

  ...

end
```

For example, you modify the line:

```ruby
state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
```

by

```ruby
state.show_field ? "Click to hide Hello People input field" : "Click to show People input field"
```

Save and you should see the text change magically in your browser without having to refresh. Pure joy.  