---
title: Installation
---
# TODO THIS PAGE NEEDS UPDATING

Locations of files:

|   Directory                 |   Contents              |   Visible on server     |   Visible on client |
|-----------------------------|-------------------------|-------------------------|---------------------|
|   app/models                |	  private AR models	    |   yes	                  |   no                |
|   app/operations	          |   private operations	  |   yes	                  |   no                |
|   app/hyperloop/components	|   components            |   for prerendering only	|   yes               |
|   app/hyperloop/stores	    |   stores	              |   yes	                  |   yes               |
|   app/hyperloop/operations	|   public operations	    |   yes	                  |   yes               |
|   app/hyperloop/models	    |   public models	        |   yes	                  |   yes               |

Hide code from client:

```
# app/hyperloop/operations/authorize_cc.rb
class AuthorizeCC < ServerOp
  param :acting_user
  param :cc_last_four
end
```

and then

```
# app/hyperloop/operations/authorize_cc_private.rb
class AuthorizeCC < ServerOp
  ... all the top secret implementation here
end unless RUBY_ENGINE == 'opal
```

or even

```
# app/operations/authorize_cc.rb
require 'hyperloop/operations/authorize.rb'
class AuthorizeCC < ServerOp
  ... all the top secret implementation here
end
```



# Installation

There are several ways to install Hyperloop into your development environment.

+ Experimenting online in the Opal playground
+ Running exclusively in your browser with Hyperloop Express
+ Integrating with the Rails Asset Pipeline
+ Building a single `application.js` with Rake
+ Using NPM and Webpack to require all your JavaScript components

## Opal Playground

A great way to start learning HyperReact is use OpalPlayground.

Here is a simple HelloWorld example to get you started.

**[HelloWorld](http://fkchang.github.io/opal-playground/?code:class%20HelloWorld%20%3C%20React%3A%3AComponent%3A%3ABase%0A%20%20param%20%3Avisitor%0A%0A%20%20def%20render%0A%20%20%20%20%22Hello%20there%20%23%7Bparams.visitor%7D%22%0A%20%20end%0Aend%0A%0A%0AElement%5B%27%23content%27%5D.render%20do%0A%20%20HelloWorld%20visitor%3A%20%22world%22%0Aend%0A%0A%0A&html_code=%3Cdiv%20id%3D%27content%27%3E%3C%2Fdiv%3E&css_code=body%20%7B%0A%20%20background%3A%20%23eeeeee%3B%0A%7D%0A)**


## Using Hyperloop Express

For small static sites that don't need a server backend you can use the reactrb-express javascript library.
Simply include the reactrb-express.js file with your other javascript code, or access it directly via the CDN, and you are good to go.

This is another great way to experiment with HyperReact.  You don't need any setup or download to get started.

[Hyperloop Express](https://github.com/reactrb/reactrb-express)

## With Rails

HyperReact works great with new or existing rails apps, and HyperReact plays well with other frameworks, so it's pain free to introduce React to your application.

We recommend you use the [HyperRails](https://github.com/ruby-hyperloop/hyper-rails) gem to do a transparent install of everything you need in a new or existing rails app.

In your `Gemfile`

```ruby
gem "hyper-rails"
```

then

```ruby
bundle install
rails g hyperloop:install
bundle update
```

If you need any help with your installation please contact us on [gitter.im](https://gitter.im/reactrb/chat)

Within a Rails app React Components are by convention stored in the `app/views/components` directory.

Your Rails controllers, and layouts access your top level components using the `render_component` method.

During server-side-rendering your components will be called on to generate the resulting HTML just like ERB or HAML templates.  The resulting HTML is delivered to the client like any other rails view, but in addition all the code needed to keep the component dynamically updating is delivered as well.  So now as events occur on the client the code is re-rendered client side with no server action required.

Because React plays well with others, you can start with a single aspect of a page or layout (a dynamic chat widget for example) and add a React component to implement that functionality.

#### Rendering Components

Once you are setup (i.e. `rails g hyperloop:install`) components may be rendered directly from a controller action by simply following a naming convention.

To render a component from the `home#show` action, create a component class named `Show`.  Note: You can use the `rails g hyperloop:component Home::Show` command to generate a component template.

```ruby
# app/views/components/home/show.rb
module Components
  module Home
    class Show < React::Component::Base

      param :say_hello_to

      def render
        puts "Rendering my first component!"
        "hello #{params.say_hello_to if params.say_hello_to}"
      end
    end
  end
end
```

To render the component call `render_component` in the controller action passing along any params:

```ruby
# controllers/home_controller.rb
class HomeController < ApplicationController
  def show
    # render_component uses the controller name to find the 'show' component.
    render_component say_hello_to: params[:say_hello_to]
  end
end
```

Or from a view:

```ruby
<%= react_component('Home::Show', say_hello_to: "Sally") %>
```

Make sure your routes file has a route to your home#show action. Visit that route in your browser and you should see 'Hello' rendered.

Open up the js console in the browser and you will see a log showing what went on during rendering.

Have a look at the sources in the console, and notice your ruby code is there, and you can set break points etc.

### Manual Rails Install

The following can easily be achieved by using the generators in [hyper-rails](https://github.com/ruby-hyperloop/hyper-rails) gem but the steps are simple if you prefer to do them yourself.

To start using HyperReact within a new or existing Rails 4.x or Rails 5.x app, follow these steps:

#### Step 1 - Add the gems

In your Gemfile:

```ruby
# Gemfile
gem 'opal-rails'
gem 'opal-browser'
gem 'hyper-react'
gem 'therubyracer', platforms: :ruby
gem 'react-router-rails', '~> 0.13.3'
gem 'hyper-router'
gem 'hyper-mesh'
```

Run `bundle install` and restart your rails server.

#### Step 2 - Add the components directory and manifest

Your react components will go into the `app/views/components/` directory of your rails app.

Within your `app/views` directory you need to create a `components.rb` manifest.

Files required in `app/views/components.rb` will be made available to the server side rendering system as well as the browser.

```ruby
# app/views/components.rb
require 'opal'
require 'react/react-source'
require 'hyper-react'
if React::IsomorphicHelpers.on_opal_client?
  require 'opal-jquery'
  require 'browser'
  require 'browser/interval'
  require 'browser/delay'
  # add any additional requires that can ONLY run on client here
end
require 'hyper-router'
require 'react_router'
require 'hyper-mesh'
require 'models'
require_tree './components'
```

#### Step 3 - Client Side Assets

Typically the client will need all the above assets, plus other files that are client only. Notably jQuery is a client only asset.

NOTE: You can update your existing application.js file, or convert it to ruby syntax and name it application.rb. The example below assumes you are using ruby syntax. However if you are using `application.js` then use the standard `//= require '...'` format and load your components with `Opal.load('components');`

Assuming you are using the ruby syntax (application.rb), in `assets/javascript/application.rb` require your components manifest as well as any additional browser only assets.

```ruby
# assets/javascript/application.rb

# Add React and make components available by requiring your components.rb manifest.
require 'react/react-source'
require 'components'

# 'react_ujs' tells react in the browser to mount rendered components.
require 'react_ujs'

# Require your other javascript assets. jQuery for example...
require 'jquery'      # You need both these files to access jQuery from Opal.
require 'opal-jquery' # They must be in this order.
require 'opal-browser'

# Finally have Opal load your components.rb
Opal.load('components')
```

#### Step 4 - Update application.rb

Finally you will need to update your `application.rb` to ensure everything works in production:

```ruby
config.eager_load_paths += %W(#{config.root}/app/models/public)
config.eager_load_paths += %W(#{config.root}/app/views/components)
config.autoload_paths += %W(#{config.root}/app/models/public)
config.autoload_paths += %W(#{config.root}/app/views/components)
config.assets.paths << ::Rails.root.join('app', 'models').to_s
```

### Rendering components

There are two ways to render a component - either directly from a controller or from a view. If you opt to render a component from a controller, pre-rendering is done by default, but if you opt to render the component via a view then pre-rendering is not done by default. There are limitations to pre-rendering (for example you cannot use JQuery) so it is up to you to decide which approach you prefer.

#### Mounting a component from a controller:

```ruby
# controllers/home_controller.rb
class HomeController < ApplicationController
  def show
    # render_component uses the controller name to find the 'show' component.
    render_component say_hello_to: params[:say_hello_to]
  end

  def index
    # or just simply with no params
    render_component
  end
```
#### Mounting a component from a view:
``` ruby
# views/home/show.html.erb
<%= react_component('Home::Show', say_hello_to: params[:say_hello_to]) %>
```

## With Sinatra

HyperReact works fine with Sinatra.  Use this [Sinatra Example App](https://github.com/reactrb/reactrb-examples) to get started.

## Building With Rake

You can also build a simple front end application with no back end consisting of one JS file, one CSS file and and index.html.

In the example below we will build a simple app.js file from a Hyper-react components using Opal.

Add the following gems, and run `bundle install`.

```ruby
# Gemfile
gem 'opal'
gem 'opal-browser' # optional
gem 'hyper-react'
gem 'opal-jquery'  # optional
```

Your rake file task will look like this:

```ruby
#rake.rb
require 'opal'
require 'hyper-react'

desc "Build app.js"
task :build do
   Opal.append_path "react_lib"
    File.open("app.js", "w+") do |out|
      out << Opal::Builder.build("application").to_s
    end
end
```

Your main `application.rb` file will look like this:

```ruby
require 'opal'
require 'browser/interval'
require 'opal-jquery'
require 'hyper-react'
require 'react/top_level_render'

class HelloWorld < React::Component::Base
  param :time, type: Time
  render do
    p do
      span { "Hello, " }
      input(type: :text, placeholder: "Your Name Here")
      span { "! It is #{params.time}"}
    end
  end
end

every(1) do
  Element["#example"].render do
    HelloWorld(time: Time.now)
  end
end
```

Run `bundle exec rake build`

This should build `app.js` which can be included in your main html file.

Your `index.html` will look like this:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">

    <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
    <script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
  	<script src="https://unpkg.com/react@15/dist/react.js"></script>
  	<script src="https://unpkg.com/react-dom@15/dist/react-dom.js"></script>

    <link rel="stylesheet" href="styles.css">
    <script src="app.js"></script>

  </head>
  <body>
    <div id="content"></div>
  </body>
</html>
```

Two things to note about the code above:

+ `<meta charset="UTF-8">` is important as this is required by Opal
+ `<div id="content"></div>` is where our Clock component will be rendered from `Element['#content'].render{ Clock() }`

As a final note, the resulting JS file may be a little large, so you might want to Gzip or uglify it.

## Deployment

There are a few deployment specific considerations:

+ The resulting compiled JavaScript files can be quite large, so you might want to add a minimise, uglify or gzip step
+ Some free deployment PaaS (Heroku for example) include low levels of memory and system resources. HyperReact may be configured in such a way that it is pre-rendering all pages before they are delivered to the browser and this can be an issue to the PaaS in a low memory environment. If the server is constrained it is better to turn pre-rendering off.

There is a most excellent [Tutorial written by Frederic ZINGG](https://github.com/fzingg/hyperloop-showcase-heroku) which takes you through a step by step guid to deploying on Heroku.

## Next Steps

Check out [the tutorials](/tutorials) to learn more.

Good luck, and welcome!
