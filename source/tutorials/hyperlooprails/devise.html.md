## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">D</span>evise with Hyperloop Tutorial

This tutorial will demonstrate how to use the popular [Devise Gem](https://github.com/plataformatec/devise) with Hyperloop. In this tutorial, we will be using the standard Devise user session ERB views for all Devise related activity (creating the user, changing the password, etc), and demonstrating how Hyperloop co-exists with Devise.

The goal of this tutorial is to show the interactivity between Hyperloop and Devise, so we will go quickly through the setup of Hyperloop and Devise. If these technologies are new to you, then this is not the ideal tutorial to start with. Please be sure to see the [Hyperloop with Rails tutorials](http://ruby-hyperloop.io/tutorials/hyperlooprails/) and the [Devise Gem](https://github.com/plataformatec/devise) first.

## Setup

Before continuing, you will need a Rails app with Hyperloop and Devise setup and working. Either clone the source code of this tutorial or run through the setup steps detailed here.

## Setup Rails, Hyperloop and Devise

If you already have Devise and Hyperloop setup you can skip this section and go directly to [Using Devise with Hyperloop](#using-devise-with-hyperloop)

This chapter that you through a basic installation of Devise and Hyperloop.

### Creating a new Rails app

Assuming you have Ruby and Rails installed, from the command line type:

`rails new devise_hyperloop`
`cd devise_hyperloop`
`bundel install`

We are going to need a User model, so let's create a simple one now:

```
rails g model User first_name:string last_name:string
rails db:migrate
```

### Installing Hyperloop and creating a simple Component

Firstly add the master Hyperloop gem to your Gemfile.

```ruby
# Gemfile
gem 'hyperloop'
```

Next run bundle:

`bundle install`

Then run the Hyperloop generator and create a simple Component:

```
rails g hyperloop:install
rails g hyper:component Helloworld
```

Next, create a route in `routes.rb` which points to the Helloworld Component we have just created.

>Note that this shortcut replaces the need for a Rails controller and view. There is an automagical `hyperloop` controller which will load the component specified. If you prefer not to take this shortcut, you can create a controller and view which will load your Helloworld Component instead. See the Hyperloop website for details on how to do this.

For this tutorial we will take the shortcut:

```ruby
# routes.rb
root 'hyperloop#helloworld'
```

Next, we should check that out transport is correctly configured. This tutorial uses ActionCable. In `config/initializers/hyperloop.rb` ensure that we have a valid transport:

```ruby
# config/initializers/hyperloop.rb
Hyperloop.configuration do |config|
  config.transport = :action_cable
end
```

To access our User Model on the client, we need to move it (and applciation_record.rb for Rails 5.x) to the `hyperloop/models` folder.

`mv app/models/user.rb app/hyperloop/models/`
`mv app/models/application_record.rb app/hyperloop/models/`

If you start your rails server and navigate to `localhost:3000`. `Helloworld` should be displayed in your browser. Admittedly this is not very exciting, but it does prove that Hyperloop is correctly installed.

### Installing Devise

Next, we will install Devise. In your `Gemfile` add:

```ruby
# Gemfile
gem 'devise'
```

Then bundle:

`bundle install`

Then run the Devise generator:

`rails generate devise:install`

As this tutorial is not about Devise but rather its connection to Hyperloop, we will do the minimal Devise setup required. Please see the Devise website for more information on setting up Devise thoroughly.

Devise needs to augment our User model, so we will run a generator for that:

```
rails g devise User
rails db:migrate
```

At this point, Devise should be setup and working. Let's test that by starting your Rails server and navigating to:

`http://localhost:3000/users/sign_up`

You should see a very basic looking signup page! Now we know that Devise is setup and working.

As a final step, we need to tell Rails to protect all our controllers with Devise. Add the following line to your `application_controller.rb`

```ruby
# application_controller.rb
before_action :authenticate_user!
```

At this stage, we have Hyperloop and Devise installed so now we will discuss how to connect them.

You will have one more configuration step to complete which is detailed here: [Using Devise with Hyperloop](#using-devise-with-hyperloop)

### Adding Devise or Hyperloop to an existing app

If you are adding Devise or Hyperloop to an existing app, please ensure that you have completed the following steps:

+ You have a Rails app with a User model
+ Hyperloop is installed and rendering Components
+ Hyperloop's transport is configured so data can move from the server to the client
+ You have moved your User model to the `hyperloop/models` folder, so that is accessible to both the client and server code
+ Devise is installed, and you have run the generator for Devise
+ Devise is protecting all our Rail controllers through a `before_action` on your ApplicationController

## Using Devise with Hyperloop

### Keeping Devise code on the server

**There is one last configuration step we need to perform. Devise has added code to our User model which we want on the server but not on the client.**

To achieve this we simply wrap the `devise` macro in an `unless RUBY_ENGINE == 'opal'` test:

```ruby
# app/hyperloop/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable unless RUBY_ENGINE == 'opal'
end
```

### Hyperloop and Devise co-existing

If you restart your Rails server and navigate to `http://localhost:3000/` you should be redirected to a Signup page.

Complete the signup, and you should be redirected to Hyperloop route which renders our Helloworld component. You should see this in your browser:

```
Welcome! You have signed up successfully.

Helloworld
```

This proves that both Devise and Hyperloop are working properly, so our next step is to link them together.

### Linking Hyperloop and Devise

Devise makes it easy to access the currently logged in User through a `current_user` helper which is available (servers-side) in your Rails Controllers and Views.

To get this information client-side, we need to link Hyperloop's (server-side) `acting_user` with Devise's `current_user` by creating an `acting_user` method on our `ApplicationController` which aliases Devise's `current_user`:

```ruby
# app/controllers/application_controller.rb
def acting_user
  current_user
end
```

Hyperloop will then call `ApplicationController::acting_user`, and set `Hyperloop::Application.acting_user_id` to the ID of `current_user`.

`Hyperloop::Application.acting_user_id` will then be available to your server and client-side code.

### Accessing `User.current` on the client

Let's update our `Helloworld` Component so that it renders the current users' email.

To keep the concept of `Hyperloop::Application.acting_user_id` out of our client-side code, we will add a class method to `User` which will find and return the `current_user` if one exists or an empty User object if no user is current:

```ruby
# app/hyperloop/models/user.rb
def self.current
  Hyperloop::Application.acting_user_id ? find(Hyperloop::Application.acting_user_id) : User.new
end
```

Now to access out `current_user` object we simply say `User.current`, so in the Helloworld Component to render the current user's email:

```ruby
# app/hyperloop/components/helloworld.rb
DIV do
  H1 {"Helloworld - #{User.current.email}"}
end
```
