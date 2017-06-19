---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">W</span>ebpacker GEM Tutorial


![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-rails-webpackergem-helloworld/master/hyperlooprailswebpackergemhelloworldscreenshot.png)


You can find the complete source code of this tutorial here: [Hyperloop with Rails Webpacker GEM app](https://github.com/ruby-hyperloop/hyperloop-rails-webpackergem-helloworld)

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further:

We are going to setup the [Webpacker GEM](https://github.com/rails/webpacker) and implement a simple HelloWorld app to show how Hyperloop and [webpack](https://webpack.js.org/) are running well together.

#### Part 1 - Webpacker GEM

##### Step 1.1 - Installing and setting up the Webpacker GEM:

Update your Gemfile file:

```ruby
#Gemfile

gem 'webpacker'

```

Then run:

```ruby
bundle update
```

Run the webpacker install generator:

```
bin/rails webpacker:install
```

##### Step 1.2 - Adding libraries into Webpack:

[Webpacker GEM](https://github.com/rails/webpacker) comes with the the [YARN](https://yarnpkg.com/en/) package manager in order to install needed libraries.

We are going to install 4 libraries required by our application:
React, React-dom, Bootstrap and Bootswatch theme.

Run these commands:

```
yarn add react
yarn add react-dom
yarn add bootstrap react-bootstrap
yarn add bootswatch
```

##### Step 1.3 - Requiring the libraires

In the `app/javascript/packs` add the following two files:

```javascript
//app/javascript/packs/client_and_server.js

ReactDOM = require('react-dom');
React = require('react');
ReactBootstrap = require('react-bootstrap');
```

```javascript
//app/javascript/packs/client_only.js

require('bootswatch/superhero/bootstrap.min.css');
```

##### Step 1.4 - Letting Webpack know React and ReactDOM are external

React and ReactDOM are being brought in by Hyperloop, so we need to let Webpack know that these libraries are external so we do not end up with more than one copy of React running. Note that you will also need to do this for your production environment.

In the `module.export` block, add the following to `development.js`:

```javascript
//config/webpack/development.js

externals: {
       "react": "React",
       "react-dom": "ReactDOM"
   },
```

##### Step 1.5 - Updating webpack bundle

Before updating our webpack bundle, let's modify a configuration parameter.
For our sample app we will not serve pack files from a Webpack-dev-server (`http://localhost:8080`). So we will modify a webpack configuration file like this:

```yaml
#config/webpack/development.server.yml

  enabled: false
  host: localhost
  port: 8080

```

##### Step 1.6 - Building the webpack bundle

**You will need to do this step whenever you make any changes to Webpack or add additional libraries though Yarn.**

Run the following commands in your console:

```
rm -rf tmp/cache/
bin/webpack
rake environment
```

Note in the above, you should always delete your cache before building your webpack assets. `rake environment` will recompile Hyperloop.

##### Step 1.7 - Configuring Rails asset pipeline:

```ruby
#config/application.rb

config.assets.paths << ::Rails.root.join('public', 'packs').to_s
```

##### Step 1.8 - Adding pack files to the asset pipeline:

By using the Hyperloop configuration file we can directly tell our app to include the pack files in the asset pipeline:

```ruby
Hyperloop.configuration do |config|
  config.transport = :simple_poller
  config.import 'client_and_server'
  config.import 'client_only', client_only: true
end
```

##### Step 1.9 - Adding CSS pack files to the asset pipeline

Add this line:

```stylesheet
//app/assets/stylesheets/application.css

*= require client_only.css
```

Note: if you prefer that your CSS pack files being directly packed into the `client_only.js` you can modify the `config/webpack/` config files and run the `rm -rf tmp/cache/; bin/webpack; rake environment` again.


#### Part 2 - Implementing the helloworld app


##### Step 2.1 - Creating the Helloworld component

Run the hyperloop generator:

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`



##### Step 2.2 - Updating Helloworld component code

Copy and paste this code into the component file you've just generated:

```ruby
#/app/hyperloop/components/helloworld.rb

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

  def show_input

    H4 do
      span{'Please type '}
      span.colored {'Hello World'}
      span{' in the input field below :'}
      br {}
      span{'Or anything you want (^̮^)'}
    end

    INPUT(type: :text, class: 'form-control').on(:change) do |e|
      state.field_value! e.target.value
    end
  end

  def show_text
    H1 { "#{state.field_value}" }
  end

end


```


##### Step 2.3 - Creating the controller

Create a `home_controller.rb` file, manually or with the command `rails g controller Home helloworld --skip-javascripts`:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
  end
end
```

##### Step 2.4 - Updating the routes.rb file

```ruby
#config/routes.rb

root 'home#helloworld'
```

##### Step 2.5 - Creating the helloworld view file:

```erb
#app/vies/home/helloworld.html.erb

<div class="hyperloophelloword">

  <div>
  	<%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
```

##### Step 2.6 - Styling

We will add a **Hyperloop** logo

```erb
#app/vies/home/helloworld.html.erb

<div class="hyperloophelloword">

  <img src="https://rawgit.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloop-logo-medium-white.png?raw=true">

  <div>
  	<%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
```

And load 1 small sample stylesheet :

```erb
#app/views/layouts/application.html.erb

<!DOCTYPE html>
<html>
  <head>
    <title>HyperloopRailsHelloworld</title>
    <%= csrf_meta_tags %>

	<link rel="stylesheet" href="https://rawgit.com/ruby-hyperloop/hyperloop-js-helloworld/master/style.css" >

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>

```

##### Final step: Running your app:

Start your Rails server and browse `http://localhost:3000`.
