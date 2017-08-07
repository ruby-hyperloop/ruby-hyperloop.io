---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">N</span>pm and Webpack Tutorial

<img src="/images/tutorials/Hyperloop-Railswebpack.gif" class="imgborder">

You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-webpack-helloworld';">Hyperloop with Rails Webpack app Source code</button>

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation#rorsetup';">Hyperloop installation with Ruby On Rails tutorial</button>

After **Hyperloop** has been installed properly we can go further:

We are going to setup [webpack](https://webpack.js.org/) and implement a simple HelloWorld app to show how Hyperloop and [webpack](https://webpack.js.org/) are running well together.

#### Part 1 - Webpack

##### Step 1.1 - Installing and setting up Webpack:

Run these three commands:

```
npm init
```

Press enter at each prompt to leave the fields empty. Agree when asked if it is okay to write the package.json file. This will create an empty package.json (which is similar to a Gemfile) in your root folder.

```
npm install webpack --save-dev
```

This installs Webpack and creates a node_modules folder. This folder contains hundreds of JavaScript dependencies.

```
npm install webpack -g
```

This enables us to run Webpack from the command line.

##### Step 1.2 - Adding libraries into Webpack:

We are going to install 4 libraries required by our application:
React, React-dom, Bootstrap and Bootswatch theme.

Run these commands:

```ruby
npm install react --save
npm install react-dom --save
npm install css-loader file-loader style-loader url-loader --save-dev
npm install bootstrap react-bootstrap --save
npm install bootswatch
```

##### Step 1.3 - Requiring the libraires

Create a `webpack` directory and then create 2 files:

```javascript
//webpack/client_and_server.js

ReactDOM = require('react-dom');
React = require('react');
ReactBootstrap = require('react-bootstrap');
```

```javascript
//webpack/client_only.js

require('bootswatch/superhero/bootstrap.min.css');
```

##### Step 1.4 - Updating webpack configuration file

```javascript
//webpack.config.js

var path = require("path");

module.exports = {
    context: __dirname,
    entry: {
      client_only:  "./webpack/client_only.js",
      client_and_server: "./webpack/client_and_server.js"
    },
    output: {
      path: path.join(__dirname, 'public', 'packs'),
      filename: "[name].js",
      publicPath: ""
    },
    module: {
      rules: [
      { test: /\.css$/,
        use: [
          {
            loader: "style-loader"
          },
          {
            loader: "css-loader"
          }
        ]
      },
      { test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff'
      },
      { test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/octet-stream'
      },
      { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader'
      },
      { test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=image/svg+xml'
      }
    ]
    },
    resolve: {
  modules: [
  path.join(__dirname, "src"),
  "node_modules"
  ]
  },
};
```



##### Step 1.5 - Updating webpack bundle

Run the command:

```
webpack
```

##### Step 1.6 - Configuring Rails asset pipeline:

```ruby
#config/application.rb

config.assets.paths << ::Rails.root.join('public', 'packs').to_s
```

##### Step 1.7 - Adding pack files to the asset pipeline:

By using the Hyperloop configuration file we can directly tell our app to include the pack files in the asset pipeline:

```ruby
Hyperloop.configuration do |config|
  config.transport = :simple_poller
  config.import 'client_and_server'
  config.import 'client_only', client_only: true
end
```


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

##### Final step - Running your app:

Start your Rails server and browse `http://localhost:3000`.

You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-webpack-helloworld';">Hyperloop with Rails Webpack app Source code</button>


<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>