## Reactrb and Rails

It is very simple to get started with Reactrb and Rails.

[The source code to this tutorial is here](https://github.com/barriehadfield/reactrb-showcase)


### Step 1: Creating a new Rails application

	rails new reactrb-showcase
	cd reactrb-showcase
	bundle install

You should have a empty Rails application

	bundle exec rails s

And in your browser

	http://localhost:3000/

You should be seeing the Rails Welcome aboard page. Great, Rails is now installed. Lets get started with the interesting stuff.

### Step 2: Adding Reactrb

[We will use the Reactrb Rails Generator Gem](https://github.com/loicboutet/reactive-rails-generator)

In your `Gemfile` under the development group add

	gem "reactrb-rails-generator"

then

	bundle install
	bundle exec rails g reactrb:install --all
	bundle update

At this stage Reactrb is installed but we don't have any components yet. Lets create one via the generator:

	rails g reactrb:component Home::Show

This will add a new Component at app/views/components/home/show.rb

```ruby
module Components
  module Home
    class Show < React::Component::Base

      # param :my_param
      # param param_with_default: "default value"
      # param :param_with_default2, default: "default value" # alternative syntax
      # param :param_with_type, type: Hash
      # param :array_of_hashes, type: [Hash]
      # collect_all_other_params_as :attributes  #collects all other params into a hash

      # The following are the most common lifecycle call backs,
      # the following are the most common lifecycle call backs
			# delete any that you are not using.
      # call backs may also reference an instance method i.e. before_mount :my_method

      before_mount do
        # any initialization particularly of state variables goes here.
        # this will execute on server (prerendering) and client.
      end

      after_mount do
        # any client only post rendering initialization goes here.
        # i.e. start timers, HTTP requests, and low level jquery operations etc.
      end

      before_update do
        # called whenever a component will be re-rerendered
      end

      before_unmount do
        # cleanup any thing (i.e. timers) before component is destroyed
      end

      def render
        div do
          "Home::Show"
        end
      end
    end
  end
end
```

Have a look at this component as the generator creates a boilerplate component and instructions for using the most common Reactrb macros. Note that Reactrb components normally inherit from class `React::Component::Base` but you are free to `include React::Component` instead if you need your component to inherit from some other class.

Also note how `params` are declared and how `before_mount` macros (and friends) macros are used. Finally note that every component must have one `render` method which must return just one DOM `element` which in this example case is a `div`.

Next let's get this simple component rendering on a page. For that we will need a rails controller and a route.

	rails g controller home

And add a route to your `routes.rb`

	root 'home#show'

And a `show` method in the HomeController which will render the component using the `render_component` helper.

```ruby
class HomeController < ApplicationController
	def show
		render_component
	end
end
```

Fire up the server with `bundle exec rails s`, refresh your browser and if all has gone well, you should be rewarded with `Home::Show` in your browser.
