
<div class="githubhyperloopheader">

<p align="center">

<a href="http://ruby-hyperloop.io/" alt="Hyperloop" title="Hyperloop">
<img width="350px" src="http://ruby-hyperloop.io/images/hyperloop-github-logo.png">
</a>

</p>

<h2 align="center">The Complete Isomorphic Ruby Framework</h2>

<br>

<a href="http://ruby-hyperloop.io/" alt="Hyperloop" title="Hyperloop">
<img src="http://ruby-hyperloop.io/images/githubhyperloopbadge.png">
</a>

<a href="http://ruby-hyperloop.io/tutorials/hyperlooprails/webpacker/" alt="Tutorial page" title="Tutorial page">
<img src="http://ruby-hyperloop.io/images/githubtutorialbadge.png">
</a>

<a href="https://gitter.im/ruby-hyperloop/chat" alt="Gitter chat" title="Gitter chat">
<img src="http://ruby-hyperloop.io/images/githubgitterbadge.png">
</a>

</div>

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">H</span>yperloop and webpacker GEM Tutorial


<img src="http://ruby-hyperloop.io/images/tutorials/Hyperloop-Railswebpacker.gif" class="imgborder">


### Prerequisites

{ [Ruby On Rails](http://rubyonrails.org/) }, { [hyperloop GEM](http://ruby-hyperloop.io) }

To set up the **Hyperloop** GEM onto the Ruby On Rails environment, please follow the <br>

<a href="http://ruby-hyperloop.io/installation/#ror" alt="Tutorial page" title="Tutorial page">
<img src="http://ruby-hyperloop.io/images/githubinstallationrorbadge.png">
</a>

### The Goals of this Tutorial

We are going to setup the [Webpacker GEM](https://github.com/rails/webpacker) and implement a simple HelloWorld app to show how Hyperloop and [webpack](https://webpack.js.org/) are running well together.

You can find the final application source code here:<br>

<a href="https://github.com/ruby-hyperloop/hyperloop-rails-webpackergem-helloworld" alt="Tutorial source code" title="Tutorial source code">
<img src="http://ruby-hyperloop.io/images/githubsourcecodebadge.png">
</a>

### Skills required

Working knowledge of Rails and Hyperloop required

<br>

## TUTORIAL

### Part 1 - Webpacker GEM

#### Step 1.1 - Installing and setting up the Webpacker GEM:

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

#### Step 1.2 - Adding libraries into Webpack:

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

#### Step 1.3 - Requiring the libraires

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

#### Step 1.4 - Letting Webpack know React and ReactDOM are external

React and ReactDOM are being brought in by Hyperloop, so we need to let Webpack know that these libraries are external so we do not end up with more than one copy of React running. Note that you will also need to do this for your production environment.

In the `module.export` block, add the following to `development.js`:

```javascript
//config/webpack/development.js

externals: {
       "react": "React",
       "react-dom": "ReactDOM"
   },
```

#### Step 1.5 - Building the webpack bundle

**You will need to do this step whenever you make any changes to Webpack or add additional libraries though Yarn.**

Run the following commands in your console:

```
rm -rf tmp/cache/
bin/webpack
rake environment
```

Note in the above, you should always delete your cache before building your webpack assets. `rake environment` will recompile Hyperloop.

<i class="flaticon-signs"></i> In the future, when you will add a new library with webpack, it can happen that it is not correctly loaded. So, in this case, we advise to delete the `node_modules` directory, re-install libraires, re-generate the webpack file and clear Hyperloop cache and browser cache:

```
rm -rf node_modules
yarn
rm -rf tmp/cache
bin/webpack

Clear Browser cache
```

#### Step 1.6 - Configuring Rails asset pipeline:

```ruby
#config/initializers/assets.rb

Rails.application.config.assets.paths << Rails.root.join('public', 'packs').to_s
```

#### Step 1.7 - Adding pack files to the asset pipeline:

By using the Hyperloop configuration file we can directly tell our app to include the pack files in the asset pipeline:

```ruby
#config/initializers/hyperloop.rb

Hyperloop.configuration do |config|
  config.transport = :simple_poller
  config.import 'client_and_server'
  config.import 'client_only', client_only: true
end
```

<i class="flaticon-signs"></i> In Rails production mode it would be necessary to include the pack files in your application main layout:

```erb
#app/views/layouts/application.tml.erb

<%= javascript_pack_tag 'client_and_server' %>
```

#### Step 1.8 - Adding CSS pack files to the asset pipeline

Add this line:

```stylesheet
//app/assets/stylesheets/application.css

*= require client_only.css
```

Note: if you prefer that your CSS pack files being directly packed into the `client_only.js` you can modify the `config/webpack/` config files and run the `rm -rf tmp/cache/; bin/webpack; rake environment` again.


### Part 2 - Implementing the helloworld app


#### Step 2.1 - Creating the Helloworld component

Run the hyperloop generator:

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`



#### Step 2.2 - Updating Helloworld component code

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


#### Step 2.3 - Creating the controller

Create a `home_controller.rb` file, manually or with the command `rails g controller Home helloworld --skip-javascripts`:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
  end
end
```

#### Step 2.4 - Updating the routes.rb file

```ruby
#config/routes.rb

root 'home#helloworld'
```

#### Step 2.5 - Creating the helloworld view file:

```erb
#app/views/home/helloworld.html.erb

<div class="hyperloophelloword">

  <div>
    <%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
```

#### Step 2.6 - Styling

We will add a **Hyperloop** logo

```erb
#app/views/home/helloworld.html.erb

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

#### Final step: Running your app:

Start your Rails server and browse `http://localhost:3000`.

<hr>

You can find the final application source code here:<br>

<a href="https://github.com/ruby-hyperloop/hyperloop-rails-webpackergem-helloworld" alt="Tutorial source code" title="Tutorial source code">
<img src="http://ruby-hyperloop.io/images/githubsourcecodebadge.png">
</a>

<br><br>

The best way to get help and contribute is to join our Gitter Chat

<a href="https://gitter.im/ruby-hyperloop/chat" alt="Gitter chat" title="Gitter chat">
<img src="http://ruby-hyperloop.io/images/githubgitterbadge.png">
</a>

</div>
