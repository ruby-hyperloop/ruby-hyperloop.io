---
title: Installation
---

# Installation

There are several ways to install Hyperloop into your development environment.

+ Running exclusively in your browser with Hyperloop.js
+ Integrating with the Rails Asset Pipeline
+ Integrating with Sinatra


## Hyperloop.js

For small static sites that don't need a server backend you can use the `hyperloop.js` javascript library.
Simply include the `hyperloop.js` file with your other javascript code, or access it directly via the CDN, and you are good to go.

This is another great way to experiment with Hyperloop. You don't need any setup or download to get started.

### Setup

First add React, JQuery, `hyperloop.js` and `opal-compiler.js` to your HTML page:

```html
<head>
  <!-- React and JQuery -->
  <script src="https://unpkg.com/react@15/dist/react.min.js"></script>
  <script src="https://unpkg.com/react-dom@15/dist/react-dom.min.js"></script>
  <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>

  <!-- Opal and Hyperloop -->
  <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/opal-compiler.min.js"></script>
  <script src="https://rawgit.com/ruby-hyperloop/hyperloop-js/master/hyperloop.min.js"></script>
</head>
```

### Simple HelloWorld

Next, specify your ruby code inside script tags or link to your ruby code using the src attribute `<script type="text/ruby" src=.../>`

```ruby
  <script type="text/ruby">
    
    class Helloworld < Hyperloop::Component

      def render
        div do
          "hello world !"
        end
      end

    end

  </script>

```

Finally, mount your Component(s) as a DOM element and specify the Component and parameters using data-tags:

```html
<body>
  <div data-hyperloop-mount="Helloworld"
       data-name="">
  </div>
</body>
```

### Tutorials

You are ready now to implement more interesting and complex Components.<br>
You can start by the first tutorial of the Hyperloop series here :

[{ Hyperloop.js HelloWorld tutorial }](/tutorials)

## With Ruby On Rails

Hyperloop works great with new or existing rails apps, so it's pain free to introduce it to your application.

Hyperloop has been tested with the most recent Ruby On Rails verions:<br> Rails (~> 4.2), Rails (~> 5.0) and the last Rails (5.1.0.rc1).


### Setup

In your `Gemfile`

```ruby
gem 'hyperloop'
```

then

```ruby
bundle install
```

Once the Hyperloop Gem and all its dependencies have been installed, it's time to run the hyperloop install generator.

```ruby
rails g hyperloop:install
```

The generator creates the hyperloop structure inside the `/app` directory :

```
/app/hyperloop/
/app/hyperloop/components
/app/hyperloop/models
/app/hyperloop/operations
/app/hyperloop/stores
```

And updates your `app/assets/javascripts/application.js` file adding this line:

```javascript
//= require hyperloop-loader
```

Finally Hyperloop needs to create tables in your database. 
just run the command:

```ruby
rails db:migrate
```

### Simple HelloWorld


You can now test it by creating a very simple Component by running the hyperloop generator :

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`

Then you create a `home_controller.rb` file:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
    render_component
  end
end
```

Don't forget to modify your `routes.rb`:

```ruby
#get 'home/helloworld'
root 'home#helloworld'
```

Start your Rails server and browse `http://localhost:3000`.<br>
You should see `Hello world` displayed by the Component.

Note:
Instead of rendering your component from a controller, you can also render it from a view like this:

```ruby
#app/views/home/helloworld.rb

<%= react_component '::Helloworld', {}, { prerender: true } %>
```


### Tutorials

You are ready now to implement more interesting and complex Components.<br>
You can start by the first tutorial of the Hyperloop series here :

[{ Hyperloop with Ruby On Rails HelloWorld tutorial }](/tutorials)


### Advanced configuration

You can find detailed information about Hyperloop configuration files and the advanced options on this page <br>[{ Advanced configuration }](/advancedconfig)


## With Sinatra

Hyperloop works fine with Sinatra.  Use this [Sinatra Example App](https://github.com/reactrb/reactrb-examples) to get started.

TODO

## Deployment

TODO

## Next Steps

Check out [the tutorials](/tutorials) to learn more.

Good luck, and welcome!
