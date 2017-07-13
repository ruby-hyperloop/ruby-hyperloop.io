---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">H</span>elloWorld Tutorial

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloophelloworldscreenshot.png)


You can find the complete source code of this tutorial here: [Hyperloop with Rails Helloworld app](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld)

## Table of contents

+ <a href="#introduction"><h4>Introduction</h4></a>
+ <a href="#chapter1"><h4>Chapter 1: Setting things up and styling</h4></a>
+ <a href="#chapter2"><h4>Chapter 2: First Hyperloop Component</h4></a>
+ <a href="#chapter3"><h4>Chapter 3: Hyperloop's jQuery wrapper</h4></a>
+ <a href="#chapter4"><h4>Chapter 4: First Hyperloop Store</h4></a>
+ <a href="#chapter5"><h4>Chapter 5: Isomorphic models and ActiveRecord API</h4></a>

## <a name="introduction">Introduction</a>

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further.

## <a name="chapter1">Chapter 1: Setting things up and styling</a>

### Step 1.1: Creating the Helloworld component

Run the hyperloop generator:

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`

### Step 1.2: Creating the controller

Create a `home_controller.rb` file, manually or with the command `rails g controller Home helloworld --skip-javascripts`:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
  end
end
```

### Step 1.3: Updating the routes.rb file

Add this line in your `routes.rb` file (better to keep the line `mount Hyperloop::Engine => '/hyperloop'` at the top of the file)

```ruby
#config/routes.rb

mount Hyperloop::Engine => '/hyperloop'
root 'home#helloworld'
``` 

### Step 1.4: Creating the helloworld view file

```erb
#app/views/home/helloworld.html.erb

<div class="hyperloophelloword">

  <div>
    <%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
```

### Step 1.5: Testing your app

Start your Rails server and browse `http://localhost:3000`.

You should see the text `Helloworld` rendered by the generic hyperloop `Component`


### Step 1.6: Styling

Before going further and play with the `Component`, we will add some style and logo.

Add a **Hyperloop** logo

```erb
#app/views/home/helloworld.html.erb

<div class="hyperloophelloword">

  <img src="https://rawgit.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloop-logo-medium-white.png?raw=true">

  <h3>The complete isomorphic ruby framework</h3>
  <br>

  <div>
    <%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
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

## <a name="chapter2">Chapter 2: First Hyperloop Component</a>

### Step 2.1: Introduction

We are going to improve our `Helloworld` component and play with `state` params, which allows us to easily change the value of a variable and so create interactive interface.

This `Component` will display a button which can be clicked to toggle an input field. Then when typing in this field the content of it will be displayed below.

### Step 2.2: Basic elements

Update the `Component` file as below:

```ruby
#/app/hyperloop/components/helloworld.rb

class Helloworld < Hyperloop::Component

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      show_input
      show_text
    end
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      "Toggle button"
    end
  end

  def show_input

    H4 do 
      SPAN{'Please type '}
      SPAN(class: 'colored') {'Hello World'}
      SPAN{' in the input field below :'}
      BR {}
      SPAN{'Or anything you want (^̮^)'}
    end

    INPUT(type: :text, class: 'form-control')

  end

  def show_text
    H1 { "input field value will be displayed here" }
  end

end

``` 

### Step 2.3: The toggle button

We are going to introduce a `state` param in order to get our toggle button working.

We will declare the `show_field` state param (with a default value equal to `false`) like this:

```ruby
state show_field: false
```

Then this `state` param value can be read like this:

```ruby
state.show_field
```

And can be changed like that:

```ruby
mutate.show_field
```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 2.3 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent2-3">

<pre>
#/app/hyperloop/components/helloworld.rb

class Helloworld < Hyperloop::Component

  state show_field: false

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      show_input
      show_text
    end if state.show_field
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
    end.on(:click) { mutate.show_field !state.show_field }
  end

  def show_input

    H4 do 
      SPAN{'Please type '}
      SPAN(class: 'colored') {'Hello World'}
      SPAN{' in the input field below :'}
      BR {}
      SPAN{'Or anything you want (^̮^)'}
    end

    INPUT(type: :text, class: 'form-control')

  end

  def show_text
    H1 { "input field value will be displayed here" }
  end

end

</pre>
</div>

Refresh your browser page, and try the new toggle button.

### Step 2.4: The input field

This time we are going to introduce a `field_value` state param with an empty default value:

```ruby
state field_value: ""
```

Then we are going to get the input field value and update the `field_value` state accordingly with the `mutate` instruction:

```ruby
INPUT(type: :text, class: 'form-control').on(:change) do |e|
  mutate.field_value e.target.value
end
```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 2.4 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent2-4">

  <pre>
  #/app/hyperloop/components/helloworld.rb

  class Helloworld < Hyperloop::Component

    state show_field: false
    state field_value: ""

    render(DIV) do
      show_button
      DIV(class: 'formdiv') do
        show_input
        show_text
      end if state.show_field
    end

    def show_button
      BUTTON(class: 'btn btn-info') do
        state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
      end.on(:click) { mutate.show_field !state.show_field }
    end

    def show_input

      H4 do 
        SPAN{'Please type '}
        SPAN(class: 'colored') {'Hello World'}
        SPAN{' in the input field below :'}
        BR {}
        SPAN{'Or anything you want (^̮^)'}
      end

      INPUT(type: :text, class: 'form-control').on(:change) do |e|
        mutate.field_value e.target.value
      end

    end

    def show_text
      H1 { "input field value will be displayed here" }
    end

  end

  </pre>
</div>

If you refresh your browser page and type something in the INPUT field, nothing will be displayed below. it's because we need to update the `show_text` method in order to display the `show_field` state param value.


### Step 2.5: Displaying the input field value

We just need to update the method like this: 

```ruby
def show_text
  H1 { "#{state.field_value}" }
end
```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 2.5 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent2-5">

  <pre>
    #/app/hyperloop/components/helloworld.rb

    class Helloworld < Hyperloop::Component

      state show_field: false
      state field_value: ""

      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          show_input
          show_text
        end if state.show_field
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) { mutate.show_field !state.show_field }
      end

      def show_input

        H4 do 
          SPAN{'Please type '}
          SPAN(class: 'colored') {'Hello World'}
          SPAN{' in the input field below :'}
          BR {}
          SPAN{'Or anything you want (^̮^)'}
        end

        INPUT(type: :text, class: 'form-control').on(:change) do |e|
          mutate.field_value e.target.value
        end

      end

      def show_text
        H1 { "#{state.field_value}" }
      end

    end

  </pre>
</div>

### Step 2.6: Testing your app

Refresh the browser page and try !

Have you seen how it's easy to play with the DOM without any javascript or JQuery piece of code. All in awesome RUBY !

## <a name="chapter3">Chapter 3: Hyperloop's jQuery wrapper</a>

### Step 3.1: Introduction

In order to manipulate DOM nodes in your RUBY code and particularly in your Components, you can use the **`Element`** class, which is a Hyperloop's jQuery wrapper.

As an example we will use it in order to Hide and Show the Hyperloop logo when clicking on the `toggle button`.

### Step 3.2: Showing/Hiding the Hyperloop logo

For doing that we will add a `toggle_logo(ev)` method, called by the `toggle_button` click event:

```ruby
def show_button
  BUTTON(class: 'btn btn-info') do
    state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
  end.on(:click) do |ev|
    mutate.show_field !state.show_field 
    toggle_logo(ev)
  end
end
```

And inside this method we will get the logo node and use the JQuery method to Show or Hide this element.

```ruby
def toggle_logo(ev)
    ev.prevent_default
    logo = Element['img']
    state.show_field ? logo.hide('slow') : logo.show('slow')
end
```

As you can see, we first test the `state.show_field` value, if it's `True`, we hide the logo, if not, we show it.

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 3.2 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent3.2">

  <pre>
    #/app/hyperloop/components/helloworld.rb

    class Helloworld < Hyperloop::Component

      state show_field: false
      state field_value: ""

      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          show_input
          show_text
        end if state.show_field
      end

      def toggle_logo(ev)
        ev.prevent_default
        logo = Element['img']
        state.show_field ? logo.hide('slow') : logo.show('slow')
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          state.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) do |ev|
          mutate.show_field !state.show_field 
          toggle_logo(ev)
        end
      end

      def show_input

        H4 do 
          SPAN{'Please type '}
          SPAN(class: 'colored') {'Hello World'}
          SPAN{' in the input field below :'}
          BR {}
          SPAN{'Or anything you want (^̮^)'}
        end

        INPUT(type: :text, class: 'form-control').on(:change) do |e|
          mutate.field_value e.target.value
        end

      end

      def show_text
        H1 { "#{state.field_value}" }
      end

    end

  </pre>
</div>

You can refresh and see the logo Hidden or Showed slowly when clicking on the `toggle_button`.

You can of course try others JQuery methods in order to play with elements of your page.


## <a name="chapter4">Chapter 4: First Hyperloop Store</a>

### Step 4.1: Introduction

Hyperloop Stores exist to hold local application state. Components read state from Stores and render accordingly.

In Chapter 2, we saw that Hyperloop `Component` can also hold local variable state, but it is tied to the `Component` itself. With a `Store`, application state can be shared by others `Components`.

### Step 4.2: Creating the Store

The first step is to create a `Store` in the Hyperloop's stores directory and declare the 2 `state` we need:

```ruby
#/app/hyperloop/stores/helloworld.rb

class MyStore < Hyperloop::Store

  state show_field: false, reader: true, scope: :class
  state :field_value, reader: true, scope: :class

end
```

You can see the documentation or others tutorials to understand what are the `reader: true, scope: :class` we added in the state declaration. For now, let's learn the basics.

Then we will update the `Component` code for using the new `Store` state variables instead of using its own one.

We will replace all `state.show_field` by `MyStore.show_field` and all `mutate.show_field` by `MyStore.mutate.show_field`. The same of course for the `field_value` variable.


So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 4.2 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent4.2">

  <pre>
    #/app/hyperloop/components/helloworld.rb


    class Helloworld < Hyperloop::Component

      
      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          show_input
          show_text
        end if MyStore.show_field
      end

      def toggle_logo(ev)
        ev.prevent_default
        logo = Element['img']
        MyStore.show_field ? logo.hide('slow') : logo.show('slow')
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) do |ev|
          MyStore.mutate.show_field !MyStore.show_field 
          toggle_logo(ev)
        end
      end

      def show_input

        H4 do 
          SPAN{'Please type '}
          SPAN(class: 'colored') {'Hello World'}
          SPAN{' in the input field below :'}
          BR {}
          SPAN{'Or anything you want (^̮^)'}
        end

        INPUT(type: :text, class: 'form-control').on(:change) do |e|
          MyStore.mutate.field_value e.target.value
        end

      end

      def show_text
        H1 { "#{MyStore.field_value}" }
      end

    end

  </pre>
</div>

### Step 4.3: Adding a method to the Store

Often, it can be useful to add a method to a `Store`, which can be called from any components and which contains all logic relative to the `state` variables manipulation.

We add the method `toggle_field` to `MyStore`: 

```ruby
#/app/hyperloop/stores/helloworld.rb

class MyStore < Hyperloop::Store

  state show_field: false, reader: true, scope: :class
  state :field_value, reader: true, scope: :class

  def self.toggle_field
    mutate.show_field !show_field
    mutate.field_value ""
  end

end
```

And in the `Component` (in the `show_button` method), instead of manipulating the `Store` variables we will let `MyStore` doing it by calling the `toggle_field` method.


```ruby
MyStore.mutate.show_field !MyStore.show_field
```

Replaced by:

```ruby
MyStore.toggle_field

```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 4.3 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent4.3">

  <pre>
    #/app/hyperloop/components/helloworld.rb

    class Helloworld < Hyperloop::Component

      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          show_input
          show_text
        end if MyStore.show_field
      end

      def toggle_logo(ev)
        ev.prevent_default
        logo = Element['img']
        MyStore.show_field ? logo.hide('slow') : logo.show('slow')
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) do |ev|
          MyStore.toggle_field 
          toggle_logo(ev)
        end
      end

      def show_input

        H4 do 
          SPAN{'Please type '}
          SPAN(class: 'colored') {'Hello World'}
          SPAN{' in the input field below :'}
          BR {}
          SPAN{'Or anything you want (^̮^)'}
        end

        INPUT(type: :text, class: 'form-control').on(:change) do |e|
          MyStore.mutate.field_value e.target.value
        end

      end

      def show_text
        H1 { "#{MyStore.field_value}" }
      end

    end

  </pre>
</div>

### Step 4.4: Components sharing the Store state.

We are now going to create a new Component named `InputBox`, and call it from our `helloworld` Component.
This `InputBox` Component will read/update some state of `MyStore`.

We copy the code inside of the `show_input` method a create a new component with it:

```ruby
#/app/hyperloop/components/input_box.rb

class InputBox < Hyperloop::Component

  def render

    DIV do
      H4 do 
        SPAN{'Please type '}
        SPAN(class: 'colored') {'Hello World'}
        SPAN{' in the input field below :'}
        BR {}
        SPAN{'Or anything you want (^̮^)'}
      end

      INPUT(type: :text, value: MyStore.field_value, class: 'form-control').on(:change) do |e|
        MyStore.mutate.field_value e.target.value
      end

    end

  end

end
```

And in the `Helloworld` Component, instead of calling the `show_input` method, we call the `InputBox()` Component.

```ruby
#/app/hyperloop/components/helloworld.rb

render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      InputBox()
      H1 { "#{MyStore.field_value}" }
    end if MyStore.field_displayed
  end

```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 4.4 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent4.4">

  <pre>
    #/app/hyperloop/components/helloworld.rb

    class Helloworld < Hyperloop::Component

      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          InputBox()
          show_text
        end if MyStore.show_field
      end

      def toggle_logo(ev)
        ev.prevent_default
        logo = Element['img']
        MyStore.show_field ? logo.hide('slow') : logo.show('slow')
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) do |ev|
          MyStore.toggle_field 
          toggle_logo(ev)
        end
      end

      
      def show_text
        H1 { "#{MyStore.field_value}" }
      end

    end

  </pre>
</div>


## <a name="chapter5">Chapter 5: Isomorphic models and ActiveRecord API</a>

With Hyperloop, your server side Models are directly accessible from your Components or Stores.

We are going to create a Model associated to a Table inside your database with one column.
And we will see how we can easily read, update, create or delete any values of your Model, just like Ruby On Rails can do with ActiveRecord on the server side.

### Step 5.1: Setting things up

Be sure to stop your Rails app server (CTRL-C) before continuing.

Create your Model:

```
rails generate model Helloworldmodel description:string
```

Migrate your database:

```
rails db:migrate
```

Move these 2 files:

```
mv app/models/application_record.rb app/hyperloop/models
mv app/models/helloworldmodel.rb app/hyperloop/models
```

You can restart your Rails server now. (Note: when lot of files has been created or modified in your Hyperloop directory, it can be usefull to clear the Rails app cache `rm -rf tmp/cache`, then when restarting your Rails app server, Hyperloop will re-precompile all files)

### Step 5.2: Saving the input field content into the database

We are going to add a `Save` button close to the input field and implement the method in order to save the content into the `description` attribute of HelloworldModel table.

We add the `save` button and call the `Helloworld` save_description method that we will implement soon:

```ruby
#/app/hyperloop/components/input_box.rb

class InputBox < Hyperloop::Component

  def render

    DIV do
      H4 do 
        SPAN{'Please type '}
        SPAN(class: 'colored') {'Hello World'}
        SPAN{' in the input field below :'}
        BR {}
        SPAN{'Or anything you want (^̮^)'}
      end

      INPUT(type: :text, value: MyStore.field_value, class: 'form-control').on(:change) do |e|
        MyStore.mutate.field_value e.target.value
      end

      BUTTON(class: 'btn btn-info') do
        "Save"
      end.on(:click) { Helloworld.save_description }

    end

  end

end

```

We add the `save_description` method, which follow the ActiveRecord model for creating a record into the database. 

```ruby
#/app/hyperloop/components/helloworld.rb

def self.save_description
  Helloworldmodel.create(:description => MyStore.field_value) do |result|
    alert "unable to save" unless result == true
  end
  alert("Data saved : #{MyStore.field_value}")
  MyStore.mutate.field_value ""
end
```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 5.2 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent5.2">

  <pre>
    #/app/hyperloop/components/helloworld.rb

    class Helloworld < Hyperloop::Component

      render(DIV) do
        show_button
        DIV(class: 'formdiv') do
          InputBox()
          show_text
        end if MyStore.show_field
      end

      def toggle_logo(ev)
        ev.prevent_default
        logo = Element['img']
        MyStore.show_field ? logo.hide('slow') : logo.show('slow')
      end

      def show_button
        BUTTON(class: 'btn btn-info') do
          MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
        end.on(:click) do |ev|
          MyStore.toggle_field 
          toggle_logo(ev)
        end
      end

      def show_text
        H1 { "#{MyStore.field_value}" }
      end

      def self.save_description
        Helloworldmodel.create(:description => MyStore.field_value) do |result|
          alert "unable to save" unless result == true
        end
        alert("Data saved : #{MyStore.field_value}")
        MyStore.mutate.field_value ""
      end

    end

  </pre>
</div>

Refresh you browser page and try typing `Hello USA` into the Input field and click the `save` button.

### Step 5.3: Listing the saved data