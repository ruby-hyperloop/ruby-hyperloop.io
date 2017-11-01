---
title: Installation
---

# <span class="bigfirstletter">I</span>nstallation

There are several ways to install Hyperloop into your development environment.

+ Running exclusively in your browser with Hyperloop.js
+ Integrating with the Rails Asset Pipeline
+ Integrating with Sinatra


## <a name="hyperloopjs"><div class="hyperlogoalone"><img src="/images/HyperloopJS.png" width="50" alt="Hypercomponents"></div>Hyperloop.js</a>

For small static sites that don't need a server backend you can use the `hyperloop.js` javascript library.
Simply include the `hyperloop.js` file with your other javascript code, or access it directly via the CDN, and you are good to go.

This is another great way to experiment with Hyperloop. You don't need any setup or download to get started.

### <a name="hyperloopjssetup">Setup</a>

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

### <a name="hyperloopjssimplehelloworld">Simple HelloWorld</a>

Next, specify your ruby code inside script tags or link to your ruby code using the src attribute `<script type="text/ruby" src=.../>`

```ruby
  <script type="text/ruby">
    
    class Helloworld < Hyperloop::Component

      def render
        DIV do
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

### <a name="hyperloopjstutorials">Tutorials</a>

You are ready now to implement more interesting and complex Components.<br>
You can start by the first tutorial of the Hyperloop series here :

<button type="button" class="btn btn-primary btn-lg btn-hyperloopjs" onclick="location.href='/tutorials/hyperloopjs/helloworld';">Hyperloop.js HelloWorld tutorial</button>

## <a name="ror"><div class="hyperlogoalone"><img src="/images/hyperloop-logo-small-pink.png" width="50" alt="Hyperloop"></div>With Ruby On Rails</a>

Hyperloop works great with new or existing rails apps, so it's pain free to introduce it to your application.

Hyperloop has been tested with the most recent Ruby On Rails verions:<br> Rails (~> 4.2), Rails (~> 5.0) and the last Rails (5.1.0). For the final Rails (~> 5.1.0), there are still few points to be aware of [Hyperloop and Rails (~> 5.1.0)](/installation-rails5.1.0) 

### <a name="rorinstall">Ruby On Rails installation</a>

If you don't already have Ruby On Rails installed on your local machine you can install it by following one of several existing tutorials (for exemple: [{ Setup Ruby On Rails on
Ubuntu 16.04 }](https://gorails.com/setup/ubuntu/16.04)) or you can use a cloud development environment like Cloud9 (follow our toturial [Hyperloop and Cloud9 setup](/tutorials/hyperlooprails/cloud9))

### <a name="rorsetup">Hyperloop setup</a>

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

To be sure everything is setting up correctly, check your `app/assets/javascripts/application.js`:

```javascript
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require hyperloop-loader

```

<i class="flaticon-signs"></i> If you don't have already Ruby On Rails installed on your local machine and you want to try Hyperloop, you can setup a workspace in [Cloud9](https://c9.io/) and also enjoy the co-development ability. 

For that just follow our [{ Hyperloop and cloud9 setup }](/tutorials/hyperlooprails/cloud9) tutorial.

### <a name="rorsimplehelloworld">Simple HelloWorld</a>


You can now test it by creating a very simple Component by running the hyperloop generator :

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`

<!-- Then you create a `home_controller.rb` file, manually or with the command `rails g controller Home helloworld --skip-javascripts`, and updtate it as following:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
    render_component
  end
end
``` -->

Modify your `routes.rb`:

```ruby
root 'hyperloop#helloworld'
```

Start your Rails server and browse `http://localhost:3000`.
<br><br>
You should see `Hello world` displayed by the Component.

<i class="flaticon-signs"></i> A component can be rendered in different ways, from a controller or view file for example. Please consult the documentation: [{ Elements and rendering }](/docs/components/docs#elements-and-rendering)







### <a name="rortutorials">Tutorials</a>

You are ready now to implement more interesting and complex Components.<br>
You can start by the first tutorial of the Hyperloop series here:

<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/tutorials/hyperlooprails/helloworld';">Hyperloop with Ruby On Rails HelloWorld tutorial</button>


### Advanced configuration

You can find detailed information about Hyperloop configuration files and the advanced options on this page: <br>

[{ Advanced configuration }](/docs/advancedconfiguration)


## With Sinatra

Hyperloop works fine with Sinatra.  Use this [Sinatra Example App](https://github.com/reactrb/reactrb-examples) to get started.

TODO

## Deployment

For learning how to deploy a hyperloop application to a production server (particularly when using Rails), you can follow our tutorials: 

[{ Hyperloop deployment }](/tutorials/hyperloopdeploy)

## Next Steps


Check out our tutorials to learn more.

<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/tutorials';">Hyperloop tutorials</button>

Good luck, and welcome!
