---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">C</span>hat-App Tutorial


<img src="https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-chatapp/master/hyperloopjschatappscreenshot.png" class="imgborder">

You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-chatapp';">Hyperloop with Rails Chat App source code</button>

## Table of contents

> <a href="#introduction"><h4>Introduction</h4></a>
> <a href="#chapter1"><h4>Chapter 1: Setting things up and styling</h4></a>
> <a href="#chapter2"><h4>Chapter 2: </h4></a>
> <a href="#chapter3"><h4>Chapter 3: </h4></a>
> <a href="#chapter4"><h4>Chapter 4: </h4></a>
> <a href="#chapter5"><h4>Chapter 5: </h4></a>
> <a href="#chapter6"><h4>Chapter 6: </h4></a>
> <a href="#chapter7"><h4>Chapter 7: </h4></a>
> <a href="#chapter8"><h4>Chapter 8: </h4></a>

<br>
<br>

## <a name="introduction">Introduction</a>

We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

During this tutorial we will learn how to use Hyperloop <a href="/docs/components/dsl-overview" class="component-blue"><b>C</b>omponents</a>, <a href="/docs/stores/overview" class="store-green"><b>S</b>tores</a> and <a href="/docs/operations/docs" class="operation-purple"><b>O</b>perations</a>. 

We will also see also how the <%= pushnotificationslink %> works. So every chatters will se all messages updated in realtime in their browser.  

<br>
<br>

## <a name="chapter1"><div class="hyperlogoalone"><img src="/images/hyperloop-logo-small-pink.png" width="50" alt="Hyperloop"></div>Chapter 1: Setting things up and styling</a>

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation#rorsetup';">Hyperloop installation with Ruby On Rails tutorial</button>

After **Hyperloop** has been installed properly we can go further.

### Step 1.1: Creating the Helloworld component

Run the hyperloop generator:

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`

### Step 1.2: Updating the routes.rb file

In order to mount your component we are going to create an URL in the routes file which will dispatch to the `helloworld` component.

Add this line in your `routes.rb` file (better to keep the line `mount Hyperloop::Engine => '/hyperloop'` at the top of the file)

```ruby
#config/routes.rb

mount Hyperloop::Engine => '/hyperloop'
root 'hyperloop#helloworld'
``` 


<br><br>
<hr>

<i class="flaticon-signs"></i> A component can be mounted in different ways, from a controller or view file for example. Please consult the documentation: [{ Elements and rendering }](/docs/components/elements-rendering/)

For example, from a View:

```erb
    <%= react_component '::Helloworld' %>
```

Or, from a Controller:

```erb
    render_component("Helloworld")
```

<hr>
<br>

### Step 1.3: Testing your app

Start your Rails server and browse `http://localhost:3000`.

You should see the text `Helloworld` rendered by the generic hyperloop `Component`


### Step 1.4: Styling

Before going further and play with the `Component`, we will add some style and logo.

We are going to add an **Hyperloop** logo. To do that you can replace the generic code of the `Helloword` Component by this one:

```ruby
#/app/hyperloop/components/helloworld.rb

class Helloworld < Hyperloop::Component

  render(DIV) do

    DIV(class: 'hyperloophelloword') do

      IMG(src: 'https://rawgit.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloop-logo-medium-white.png?raw=true')
      H3 { "The complete isomorphic ruby framework" }
      BR{}

    end

  end

end

```

And load 2 stylesheets:

```erb
#app/views/layouts/application.html.erb

<!DOCTYPE html>
<html>
  <head>
    <title>HyperloopRailsHelloworld</title>
    <%= csrf_meta_tags %>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">

    <link rel="stylesheet" href="https://rawgit.com/ruby-hyperloop/hyperloop-js-helloworld/master/style.css" >

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>

```
<br>






































We'll be building a simple but realistic chat application, a basic version of a chat room offered by a service like gitter.im.

During this tutorial we will learn how to use Hyperloop <%= componentslink %>, <%= storeslink %> and <%= operationslink %>. 

We will also see also how the <%= pushnotificationslink %> works. So every chatters will se all messages updated in realtime in their browser.  

<img src="/images/tutorials/HyperloopJS-Chatapp.gif" class="imgborder">


You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-chatapp';">Hyperloop with Rails ChatApp Source code</button>

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation#rorsetup';">Hyperloop installation with Ruby On Rails tutorial</button>

After **Hyperloop** has been installed properly we can go further:

#### Step 1: Creating the Chatapp component

Run the hyperloop generator:

```
rails g hyper:component Chatapp
```

You can view the new Component created in `/app/hyperloop/components/`

```ruby
class HomeController < ApplicationController
  def chatapp
    render_component
  end
end
```


```ruby
#config/routes.rb

root 'home#chatapp'
```




```ruby
#/app/hyperloop/components/chatapp.rb

  class Chatapp < Hyperloop::Component

    def render
      DIV do
        Nav()
        
      end
    end
    
  end
 ```


 ```ruby
 #/app/hyperloop/components/nav.rb

 class Nav < Hyperloop::Component

  before_mount do
    mutate.user_name_input ''
  end

  render do
    div.navbar.navbar_inverse.navbar_fixed_top do
      div.container do
        div.collapse.navbar_collapse(id: 'navbar') do
          form.navbar_form.navbar_left(role: :search) do
            div.form_group do
              input.form_control(type: :text, value: state.user_name_input, placeholder: "Enter Your Handle"
              ).on(:change) do |e|
                mutate.user_name_input e.target.value
              end
              button.btn.btn_default(type: :button) { "login!" }.on(:click) do
                Operations::Join(user_name: state.user_name_input)
              end if valid_new_input?
            end
          end
        end
      end
    end
  end

  def valid_new_input?
    state.user_name_input.present? && state.user_name_input != MessageStore.user_name
  end
end
```

```ruby
#/app/hyperloop/stores/message_store.rb

class MessageStore < Hyperloop::Store
  
  state :user_name, scope: :class, reader: true

  receives Operations::Join do |params|
    puts "receiving Operations::Join(#{params})"
    mutate.user_name params.user_name
  end

 
end
```

todo

You can find the complete source code of this tutorial here: 

<button type="button" class="btn btn-primary btn-lg btn-hyperlooptrace" onclick="location.href='https://github.com/ruby-hyperloop/hyperloop-rails-chatapp';">Hyperloop with Rails ChatApp Source code</button>


<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>