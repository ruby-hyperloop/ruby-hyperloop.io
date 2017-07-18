---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">H</span>elloWorld Tutorial

<img src="/images/tutorials/Hyperloop-helloworld.png" class="imgborder">


You can find the complete source code of this tutorial here: [Hyperloop with Rails Helloworld app](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld)

## Table of contents

> <a href="#introduction"><h4>Introduction</h4></a>
> <a href="#chapter1"><h4>Chapter 1: Setting things up and styling</h4></a>
> <a href="#chapter2"><h4>Chapter 2: First Hyperloop Component</h4></a>
> <a href="#chapter3"><h4>Chapter 3: Hyperloop's jQuery wrapper</h4></a>
> <a href="#chapter4"><h4>Chapter 4: First Hyperloop Store</h4></a>
> <a href="#chapter5"><h4>Chapter 5: First Isomorphic Model</h4></a>
> <a href="#chapter6"><h4>Chapter 6: First Hyperloop Operation</h4></a>
> <a href="#chapter7"><h4>Chapter 7: First Hyperloop Server Operation</h4></a>

<br>
<br>

## <a name="introduction">Introduction</a>

This simple tutorial will teach you the basic of using each Hyperloop architecture brick: <a href="/docs/components/dsl-overview" class="component-blue"><b>C</b>omponents</a>, <a href="/docs/stores/overview" class="store-green"><b>S</b>tores</a>, <a href="/docs/models/active-record" class="model-orange"><b>I</b>somorphic models and ActiveRecord API</a>,  <a href="/docs/operations/overview" class="operation-purple"><b>O</b>perations</a>, <a href="/docs/operations/overview/#server-operations" class="operation-purple"><b>S</b>erver <b>O</b>perations</a>, each one introduced step by step, within a Ruby On Rails environment. 

At the end of this tutorial, we will have a simple app which will:

+ Display a toggle button showing/hiding an input field and a save button.
+ When clicking on this save button, the content of the input field will be saved into a database and a list of all records will be displayed and updated automatically.
+ Display a message field with a send button.
+ When clicking on the send button, the content of the message field will be saved into the Rails Cache and a list of all messages will be displayed and updated automatically.

<br>
<br>

## <a name="chapter1"><div class="hyperlogoalone"><img src="/images/hyperloop-logo-small-pink.png" width="50" alt="Hyperloop"></div>Chapter 1: Setting things up and styling</a>

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further.

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

<br>
<br>

## <a name="chapter2"><div class="hyperlogoalone"><img src="/images/HyperComponents.png" width="50" alt="Hypercomponents"></div>Chapter 2: First Hyperloop Component</a>

### Step 2.1: Introduction

Hyperloop Components are subclasses of `Hyperloop::Component`.<br>
[{ Hyperloop Components documentation }](http://ruby-hyperloop.io/docs/components/dsl-overview/)

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

<br>
<br>

## <a name="chapter3"><div class="hyperlogoalone"><img src="/images/hyperloop-logo-small-pink.png" width="50" alt="Hyperloop"></div>Chapter 3: Hyperloop's jQuery wrapper</a>

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

<br>
<br>

## <a name="chapter4"><div class="hyperlogoalone"><img src="/images/HyperStores.png" width="50" alt="Hyperloop"></div>Chapter 4: First Hyperloop Store</a>

### Step 4.1: Introduction

Hyperloop Stores are subclasses of `Hyperloop::Store`.<br>
[{ Hyperloop Stores documentation }](http://ruby-hyperloop.io/docs/stores/overview/)

Hyperloop Stores exist to hold local application state. Components read state from Stores and render accordingly.

In Chapter 2, we saw that Hyperloop `Component` can also hold local variable state, but it is tied to the `Component` itself. With a `Store`, application state can be shared by others `Components`.

### Step 4.2: Creating the Store

The first step is to create a `Store` in the Hyperloop's stores directory and declare the 2 `state` we need:

```ruby
#/app/hyperloop/stores/mystore.rb

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
#/app/hyperloop/components/mystore.rb


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
#/app/hyperloop/stores/mystore.rb

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

<br>
<br>

## <a name="chapter5"><div class="hyperlogoalone"><img src="/images/HyperModels.png" width="50" alt="Hyperloop"></div>Chapter 5: First Isomorphic Model</a>

### Step 5.1: Introduction

With Hyperloop, your server side Models are directly accessible from your Components or Stores.<br>
[{ Hyperloop Isomorphic Models documentation }](http://ruby-hyperloop.io/docs/models/overview/)

We are going to create a Model associated to a Table inside your database with one column.
And we will see how we can easily read, update, create or delete any values of your Model, just like Ruby On Rails can do with ActiveRecord on the server side.

### Step 5.2: Setting things up

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

### Step 5.3: Saving the input field content into the database

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
  data-heading="Step 5.3 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent5.3">

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

### Step 5.4: Listing the saved data

We are going to add a TABLE listing all `description` fields saved in our Database.

For that we need first to load all these data from the database, and just before the `Helloworld` component will mounted.

To do that, we will use the `before_mount` Hyperloop block. Everything put inside this block will be executed just before the rendering of the component.

```ruby
#/app/hyperloop/components/helloworld.rb

before_mount do
  @helloworldmodels = Helloworldmodel.all
end

```

Then we will render the TABLE by calling a `description_table` method that we will put in our component as well and which will display each `description` record row by row:

```ruby
#/app/hyperloop/components/helloworld.rb

render(DIV) do
  show_button
  DIV(class: 'formdiv') do
    InputBox2()
    H1 { "#{MyStore.field_value}" }
  end if MyStore.field_displayed
  description_table
end

def description_table
  DIV do
    BR
    TABLE(class: 'table table-hover table-condensed') do
      THEAD do
        TR(class: 'table-danger') do
          TD(width: '33%') { "SAVED HELLO WORLD" }
        end
      end
      TBODY do
        @helloworldmodels.each do |helloworldmodel|
          TR(class: 'table-success') do
            TD(width: '50%') { helloworldmodel.description }
          end
        end
      end
    end
  end
end

```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 5.4 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent5.4">

<pre>
#/app/hyperloop/components/helloworld.rb

class Helloworld < Hyperloop::Component

  before_mount do
    @helloworldmodels = Helloworldmodel.all
  end

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      InputBox()
      show_text
    end if MyStore.show_field
    description_table
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

  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SAVED HELLO WORLD" }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            TR(class: 'table-success') do
              TD(width: '50%') { helloworldmodel.description }
            end
          end
        end
      end
    end
  end

end

</pre>
</div>

Refresh you browser page and you should see the Table listing your previous `Hello USA`. Try to add another `Nihao China` into your input field, then after clicking the SAVE button, you will see that the Table listing is automatically updated.


### Step 5.5: Push notifications mechanism

Hyperloop includes by default a push notifications mechanism. Components datas are directly updated via browsers `Web Sockets`. Of course everything is parametrable, like which mechanism you want to use (Action-cable, pusher, ...) and more important, Hyperloop uses Policies to regulate what connections are opened between clients and the server and what data is distributed over those connections.
<br>
[{ Configuring Push notifications transport }](http://ruby-hyperloop.io/docs/models/configuring-transport/)
<br>
[{ Hyperloop Policies }](http://ruby-hyperloop.io/docs/policies/authorization/)

In order to see Puch Notifications in action, you just have to open 2 different browsers, go to `http://localhost:3000` on each browser, add and save a message in the input field, and you will see that the saved record will be displayed directly in both browsers.

### Step 5.6: Simplfiying code by adding another Component

We are going to add another `Component` in order to simplify the code and to show how `Components` can be nested.

Modify the `description_table` like that:

```ruby
#/app/hyperloop/components/helloworld.rb

def description_table

  DIV do
    BR
    TABLE(class: 'table table-hover table-condensed') do
      THEAD do
        TR(class: 'table-danger') do
          TD(width: '33%') { "SAVED HELLO WORLD" }
        end
      end
      TBODY do
        @helloworldmodels.each do |helloworldmodel|
          DescriptionRow(descriptionparam: helloworldmodel.description)
        end
      end
    end
  end

end

```

We now mount a new `DescriptionRow` component and pass a parameter containing the `description` field value.

We now create this new `DescriptionRow` component:

```ruby
#/app/hyperloop/components/description_row.rb

class DescriptionRow < Hyperloop::Component
  
  param :descriptionparam

  def render
    TR(class: 'table-success') do
      TD(width: '50%') { params.descriptionparam }
    end
  end

end

```

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 5.6 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent5.6">

<pre>
#/app/hyperloop/components/helloworld.rb


class Helloworld < Hyperloop::Component

  before_mount do
    @helloworldmodels = Helloworldmodel.all
  end

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      InputBox()
      show_text
    end if MyStore.show_field
    description_table
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

  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SAVED HELLO WORLD" }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparam: helloworldmodel.description)
          end
        end
      end
    end
  end

end

</pre>
</div>

<br>
<br>

## <a name="chapter6"><div class="hyperlogoalone"><img src="/images/HyperOperations.png" width="50" alt="Hyperloop"></div>Chapter 6: First Hyperloop Operation</a>

### Step 6.1: Introduction

Hyperloop Operations classes are subclasses of `Hyperloop::Operation`.<br>
[{ Hyperloop Operations documentation}](http://ruby-hyperloop.io/docs/operations/overview/)

`Operations` are the engine rooms of Hyperloop, they orchestrate the interactions between `Components`, external services, Models and Stores. **Operations are where your business logic lives**.

`Operations` start to be very usefull when your application is becoming complex with lot of interactions between `Components`, `Models` and `Stores`.

So the using of `Operations` in our Tutorial could seem inappropriate, but it allows us to introduce the syntax and gives us a preview of its utility.

You will have a better idea of the power of `Operations` by following these 2 Tutorials:<br>
[{ Five letters game tutorial }](http://ruby-hyperloop.io/tutorials/hyperlooprails/fivelettergame/)<br>
[{ Chat App Tutorial }](http://ruby-hyperloop.io/tutorials/hyperlooprails/chatapp/)

### Step 6.2: The ShowButton Operation

We are going to let an `Operation` do the business logic happening when clicking on the `Show input field` button.

We are going to replace:

```ruby
#/app/hyperloop/components/helloworld.rb

def show_button
  BUTTON(class: 'btn btn-info') do
    MyStore.field_displayed ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
  end.on(:click) do |ev|
    MyStore.toggle_field
    toggle_logo(ev)
  end
end

```

By

```ruby
#/app/hyperloop/components/helloworld.rb

def show_button
  BUTTON(class: 'btn btn-info') do
    MyStore.field_displayed ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
  end.on(:click) do |ev|
    ShowButtonOp.run(ev: ev)
  end
end
```

You can see the line:

```ruby
ShowButtonOp.run(ev: ev)
```

Which will run the `ShowButtonOp` Operation with passing the `event` as a parameter.

We create the `show_button_op.rb` file and the `ShowButtonOp` Class:

```ruby
#/app/hyperloop/operations/show_button_op.rb

class ShowButtonOp < Hyperloop::Operation

  param :ev

  step { MyStore.toggle_field }
  step { Helloworld.toggle_logo(params.ev) }

end

```

You can notice specific syntax: `Hyperloop::Operation` declaration and the `step` instruction. [{ Operations documentation }](http://ruby-hyperloop.io/docs/operations/overview/#defining-execution-steps)

And one last modification, the `toggle_logo` definition method needs to be updated by adding `self`:

```ruby
def self.toggle_logo(ev)
  ev.prevent_default
  logo = Element['img']
  MyStore.show_field ? logo.hide('slow') : logo.show('slow')
end
```


So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 6.2 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent6.2">

<pre>
#/app/hyperloop/components/helloworld.rb


class Helloworld < Hyperloop::Component

  before_mount do
    @helloworldmodels = Helloworldmodel.all
  end

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      InputBox()
      show_text
    end if MyStore.show_field
    description_table
  end

  def self.toggle_logo(ev)
    ev.prevent_default
    logo = Element['img']
    MyStore.show_field ? logo.hide('slow') : logo.show('slow')
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
    end.on(:click) do |ev|
      ShowButtonOp.run(ev: ev)
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

  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SAVED HELLO WORLD" }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparam: helloworldmodel.description)
          end
        end
      end
    end
  end

end

</pre>
</div>


### Step 6.3: The SaveDescriptionOp Operation

There is another business logic we can move to an `Operation`: The `save_description` method.

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

When clicking on the `Save` button, we will run an `Operation` which will Create the record into the Database then the `MyStore` Store will receive the signal that the `Operation` has been run succesfully, it will display the success message and mutate the `field_value` param.

With this exemple you can see how `Operations` and `Stores` interact together.

First, we remove the `save_description` method from the `Helloworld` component.

Then we update the `InputBox` component, replacing `Helloworld.save_description` by `SaveDescriptionOp.run`:

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
      end.on(:click) { SaveDescriptionOp.run }

    end

  end

end

```

We create the `save_description_op.rb` file:

```ruby 
#/app/hyperloop/operations/save_description_op.rb

class SaveDescriptionOp < Hyperloop::Operation

  step do
    
    Helloworldmodel.create(:description => MyStore.field_value) do |result|
      alert "unable to save" unless result == true
    end
    
  end

end
```

And we update the Store `MyStore`:

```ruby
#/app/hyperloop/stores/mystore.rb

class MyStore < Hyperloop::Store

  state show_field: false, reader: true, scope: :class
  state :field_value, reader: true, scope: :class

  def self.toggle_field
    mutate.show_field !show_field
    mutate.field_value ""
  end

  receives SaveDescriptionOp do 
    alert("Data saved : #{MyStore.field_value}")
    MyStore.mutate.field_value ""
  end

end

```

You can notice the `receives SaveDescriptionOp do .... end` block. [{ Stores documentation }](http://ruby-hyperloop.io/docs/stores/overview/#receiving-operation-dispatches)


So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 6.3 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent6.3">

<pre>
#/app/hyperloop/components/helloworld.rb

class Helloworld < Hyperloop::Component

  before_mount do
    @helloworldmodels = Helloworldmodel.all
  end

  render(DIV) do
    show_button
    DIV(class: 'formdiv') do
      InputBox()
      show_text
    end if MyStore.show_field
    description_table
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
      ShowButtonOp.run(ev: ev)
    end
  end

  def show_text
    H1 { "#{MyStore.field_value}" }
  end

  
  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SAVED HELLO WORLD" }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparam: helloworldmodel.description)
          end
        end
      end
    end
  end

end



</pre>
</div>

<br>
<br>

## <a name="chapter7"><div class="hyperlogoalone"><img src="/images/HyperOperations.png" width="50" alt="Hyperloop"></div>Chapter 7: First Hyperloop Server Operation</a>


### Step 7.1: Introduction

Hyperloop Server Operations are subclasses of `Hyperloop::ServerOp`.<br>
[{ Hyperloop Server Operations documentation }](http://ruby-hyperloop.io/docs/operations/overview/#server-operations)

`Operations` will run on the client or the server, but `Server Operations` will always run on the server even if invoked on the client.

`Server Operations` start to be usefull when your application becomes complex and needs, for example, Server side authorization, Server side payment or Server side files maniupulation.

So for our simple tutorial it will be more question of being familiar with the syntax than implementing a useful fonctionnality.

You will have a better idea of the power of `Server Operations` by following this Tutorial:<br>
[{ Chat App Tutorial }](http://ruby-hyperloop.io/tutorials/hyperlooprails/chatapp/)

### Step 7.2: What functionality we will implement ?

We will implement a simple Chatting functionality:

1. Display a message INPUT field with a send button.
2. Get all sent messages from the Rails Cache (`Rails.cache.fetch`) using a `Server Operation`
3. Save new messages in the Rails Cache (`Rails.cache.write`) using a `Server Operation`
4. Display all messages on the web page.

### Step 7.3: Which files we're going to update and create ?

File we are going to update:

1 Component:
> `app/hyperloop/components/helloworld.rb`

Files we are going to create:

3 Components: 
> `app/hyperloop/components/input_message.rb`<br> 
> `app/hyperloop/components/messages.rb`<br> 
> `app/hyperloop/components/message.rb` 

1 Store:
> `app/hyperloop/stores/message_store.rb`

1 module (named `MessagesOperations`) containing 2 Server Operations:
> `app/hyperlopp/operations/messages_operations.rb`

### Step 7.4: Execution cycles description

Our Chatting application will run 3 different and separate cycles:

1. The `Send` message cycle
> + The `Helloworld` Component mounts the `InputMessage` component<br>
> + The `InputMessage` Component displays an input field and a send message BUTTON<br>
> + When clicked, the BUTTON runs the `Send` Server Operation<br>
> + The `Send` Server Operation is executed on the Server in order to write the message into the Rails Cache.<br>
> + The Store `MessageStore` (when it is aware the `Send` Server Operation is completed) add the last sent message to the state parameter `messages` in order to keep this variable up to date.

2. The `Get` messages cycle
> + When the app is run for the first time in a browser page, the `GetMessages` Server Operation is run.<br>
> + The `GetMessages` Server Operation is executed on the Server in order to read all messages stored in the Rails Cache.
> + The Store `MessageStore` (when it is aware the `GetMessages` Server Operation is completed) update the state parameter `messages` with all messages get from the Rails Cache.

3. The `Display` messages cycle
> + The `Helloworld` Component mounts the `Messages` component<br>
> + The `Messages` Component, for each message stored in the state messages param, mounts the `Message` component<br>
> + The `Message` Component displays the message content on the page.

### Step 7.5: Setting Rails cache up

For the purpose of this tutorial we will configure our Rails app cache like this:

```ruby
#config/environments/development.rb

if Rails.root.join('tmp/caching-dev.txt').exist?
  config.action_controller.perform_caching = true

  config.cache_store = :memory_store
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=172800'
  }
else
  config.action_controller.perform_caching = true
  config.cache_store = :file_store, "tmp/cache"
end

```

### Step 7.6: Updating the Helloword Component

In our `helloworld.rb` file we are going to:

1. Mount the `InputMessage` component:

```ruby
#/app/hyperloop/components/helloworld.rb

render(DIV) do
    InputMessage()
    ...
    ...
  end

```

2. Mount the `Messages` Component, if there are messages to display:

```ruby
#/app/hyperloop/components/helloworld.rb

render(DIV) do
  ...
  ...
  if MessageStore.messages?
      Messages()
  end
end

```

`MessageStore.messages?` is a method of the MessagesStore we will implement in the next steps.

3. Run the `GetMessages` Operation to get all existing messages:

```ruby
#/app/hyperloop/components/helloworld.rb

after_mount do
  MessagesOperations::GetMessages.run
end

```

`after_mount` is a hyperloop block which is run just after the `helloworld` Component is mounted.

`MessagesOperations` is the name of the module we will create and containing the 2 Server Operations `Send` and `GetMessages`.

So, for this step, the `Component` code will be like that:

<div class="togglecode" 
  data-heading="Step 7.6 Helloworld Component" 
  data-rows=16
  data-top-level-component="HelloworldComponent7.6">

<pre>
#/app/hyperloop/components/helloworld.rb


class Helloworld < Hyperloop::Component

  before_mount do
    @helloworldmodels = Helloworldmodel.all
  end

  after_mount do
    MessagesOperations::GetMessages.run
  end

  render(DIV) do
    InputMessage()
    show_button
    DIV(class: 'formdiv') do
      InputBox3()
      H1 { "#{MyStore.field_value}" }
    end if MyStore.show_field
    
    description_table

    if MessageStore.messages?
        Messages()
    end

  end

  def self.toggle_logo(ev)
    ev.prevent_default
    logo = Element['img']
    MyStore.show_field ? logo.hide('slow') : logo.show('slow')
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      MyStore.show_field ? "Click to hide HelloWorld input field" : "Click to show HelloWorld input field"
    end.on(:click) do |ev|
      ShowButtonOp.run(ev: ev)
    end
  end

  def show_text
    H1 { "#{MyStore.field_value}" }
  end

  
  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SAVED HELLO WORLD" }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparam: helloworldmodel.description)
          end
        end
      end
    end
  end

end

</pre>
</div>


### Step 7.7: Writing the InputMessage Component

The `InputMessage` Component is very similar to the previous `InputBox` Component we wrote previously.

We use a `message_field` state param in order to store the message Input field value;

```ruby
#/app/hyperloop/components/input_message.rb

state message_field: "Type your message here"
```

And when the `Send` button is clicked we run the `Send` Operation with passing the `message_field` state value as a parameter:

```ruby
#/app/hyperloop/components/input_message.rb

BUTTON(class: 'btn btn-warning') do
  "Send"
end.on(:click) do |ev|
  MessagesOperations::Send(message: state.message_field)
end
```

The `InputMessage` Component code will be like that:

<div class="togglecode" 
  data-heading="Step 7.7 InputMessage Component" 
  data-rows=16
  data-top-level-component="InputMessageComponent7.7">

<pre>
#/app/hyperloop/components/input_message.rb


class InputMessage < Hyperloop::Component

  state message_field: "Type your message here"

  def render

    DIV(class: 'formdiv') do
      DIV(class: 'input-datas') do

        HR {}

        INPUT(type: :text, value: state.message_field,  class: 'form-control')
        .on(:change) do |e|
            mutate.message_field e.target.value
          end
          .on(:focus) do |e|
            mutate.message_field " "
          end
          
          
          BUTTON(class: 'btn btn-warning') do
            "Send"
          end.on(:click) do |ev|
            MessagesOperations::Send(message: state.message_field)
          end

          HR {}

      end
    end

  end

end

</pre>
</div>

### Step 7.8: Writing the Messages Component

The `Messages` Component will display the TABLE containing rows with all messages content.

It will loop trough the MessageStore messages state variable. This state variable is Hash of messages. Then for each message, the `Message` Component is mounted. So our component will: 

```ruby 
#/app/hyperloop/components/messages.rb

...
TBODY do
  MessageStore.all.each do |message|
    Message message: message
  end
end
...

```

The `all` method will be defined in our `MessageStore` in the next steps.

The `Messages` Component code will be like that:

<div class="togglecode" 
  data-heading="Step 7.8 Messages Component" 
  data-rows=16
  data-top-level-component="MessagesComponent7.8">

<pre>
#/app/hyperloop/components/messages.rb

class Messages < Hyperloop::Component
  
  def render

      DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do

        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SENT MESSAGES" }
          end
        end

        TBODY do
          MessageStore.all.each do |message|
            Message message: message
        end
        end

      end
    end

  end

end

</pre>
</div>

### Step 7.9: Writing the Message Component

The `Message` component will just render a simple row containg the message value:

```ruby
#/app/hyperloop/components/message.rb

...
params.message[:message]
...

```

The `Messages` Component code will be like that:

<div class="togglecode" 
  data-heading="Step 7.9 Message Component" 
  data-rows=16
  data-top-level-component="MessageComponent7.9">

<pre>
#/app/hyperloop/components/message.rb

class Message < Hyperloop::Component
  param :message

  def render
     TR(class: 'table-success') do
         TD(width: '50%') { params.message[:message] }
      end
   end

end

</pre>
</div>


### Step 7.10: Writing the MessageStore Store

In our `MessageStore` we are going to:

Declare a `messages` Hash state variable and define the `all` method:

```ruby
#app/hyperloop/stores/message_store.rb

state :messages, scope: :class, reader: :all
```

Define a `messages?` method to check if messages existed:

```ruby
#app/hyperloop/stores/message_store.rb

def self.messages?
  state.messages
end
```

Set the `state.messages` variable when receiving the `Getmessages` operation completed signal:

```ruby
#app/hyperloop/stores/message_store.rb

receives MessagesOperations::GetMessages do |params|
  puts "receiving Operations::GetMessages(#{params})"
  mutate.messages params.messages
end
```

Update the `state.messages` variable when receiving the `Send` Operation completed signal:

```ruby
#app/hyperloop/stores/message_store.rb

receives MessagesOperations::Send do |params|
  puts "receiving Operations::Send(#{params})"
  mutate.messages << params.message
end
```

Note: You can see the `PUTS` instruction. It is really usefull when debugging your code. Everything you `PUTS` will be displayed in your Browser Javascript Console.

The `MessageStore` Store code will be like that:

<div class="togglecode" 
  data-heading="Step 7.10 MessageStore Store" 
  data-rows=16
  data-top-level-component="MessageStore7.10">

<pre>
#/app/hyperloop/stores/message_store.rb

class MessageStore < Hyperloop::Store
  state :messages, scope: :class, reader: :all
  #state :user_name, scope: :class, reader: true

  def self.messages?
    state.messages
  end

  receives MessagesOperations::GetMessages do |params|
    puts "receiving Operations::GetMessages(#{params})"
    mutate.messages params.messages
  end

  receives MessagesOperations::Send do |params|
    puts "receiving Operations::Send(#{params})"
    mutate.messages << params.message
  end
end

</pre>
</div>

### Step 7.11: Writing the MessageOperations module

#### Step 7.11.a: The MessageOperations module structure

As we described it before, we are going to write 2 `Server Operations` class: `Send` and `GetMessages`.

Let's go with the file structure:

```ruby
#app/hyperloop/operations/messages_operations.rb

module MessagesOperations

  class GetMessages < Hyperloop::ServerOp
    # Get messages from the Rails Cache
  end

  class Send < Hyperloop::ServerOp
    # Get Messages from the Rails Cache and add the new message just sent by the user.
  end

end

```

#### Step 7.11.b: Server Operations specific settings

In each `Server Operations` method we will add Hyperloop specific instructions: 

```ruby
#app/hyperloop/operations/messages_operations.rb

module MessagesOperations

  class GetMessages < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    # Get messages from the Rails Cache
  end

  class Send < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    # Get Messages from the Rails Cache and add the new message just sent by the user.
  end

end

``` 

These 2 instructions are necessary for Authorization (because Server Operations run on the Server) and for Broadcasting to clients.

For the purpose of our tutorial we set up them as basic as possible.

You can know more about:<br>
[{ Hyperloop Server Operations documentation }](http://ruby-hyperloop.io/docs/operations/overview/#server-operations)<br>
[{ Hyperloop dispatching from Server Operations documentation }](http://ruby-hyperloop.io/docs/operations/overview/#dispatching-from-server-operations)<br>
[{ Hyperloop policies for Authorizations }](http://ruby-hyperloop.io/docs/policies/authorization/)<br>

#### Step 7.11.c: Writing the GetMessages Server Operation

We now are going to take care of the `GetMessages` Server Operation code.

We declare a new Hash variable `messages` which will receive the content of the Rails Cache: 

```ruby
#app/hyperloop/operations/messages_operations.rb

...
class GetMessages < Hyperloop::ServerOp
  param :acting_user, nils: true
  dispatch_to { Hyperloop::Application }
  outbound :messages

  # Get messages from the Rails Cache
end

...

```

We use the specific `outbound` Hyperloop declaration. The `messages` variable is not a classic parameter because is not needed by `GetMessages`, but we need to manipulate this `messages` variable in our `MessagesStore`. So when you need a variable being dispatched to your Stores you declare it as `outbound`.

Now we can get the content of the Rails Cache:

```ruby
#app/hyperloop/operations/messages_operations.rb

...
class GetMessages < Hyperloop::ServerOp
  param :acting_user, nils: true
  dispatch_to { Hyperloop::Application }
  outbound :messages

  step { params.messages = Rails.cache.fetch('messages') { [] } }
end

...

```

The `Rails.cache.fetch('messages') { [] } }` block will read the `messages` key in the Rails Cache and return its content or an empty hash `[]` if not exists.

#### Step 7.11.d: Writing the Send Server Operation

The `Send` Server Operation will:

+ Receive the new message being sent
+ Get the Rails Cache messages Hash
+ Add the new message 
+ Write the updated Hash to the Rails Cache.

```ruby
#app/hyperloop/operations/messages_operations.rb

...

class Send < Hyperloop::ServerOp
  param :message
  param :acting_user, nils: true
  dispatch_to { Hyperloop::Application }

  step do
    params.message = { message: params.message }
    newcachedmessages = Rails.cache.fetch('messages') { [] } << params.message
    Rails.cache.write('messages', newcachedmessages)
  end
end

...
```

#### Step 7.11.e: The final MessagesOperations module code

<div class="togglecode" 
  data-heading="Step 7.11.e MessageOperations module" 
  data-rows=16
  data-top-level-component="MessageOperations7.11.e">

<pre>
#/app/hyperloop/operations/messages_operations.rb

module MessagesOperations

  class GetMessages < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }
    outbound :messages

    step { params.messages = Rails.cache.fetch('messages') { [] } }
  end

  class Send < Hyperloop::ServerOp
    param :message
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    step do
      params.message = { message: params.message }
      newcachedmessages = Rails.cache.fetch('messages') { [] } << params.message
      Rails.cache.write('messages', newcachedmessages)
    end
  end

end

</pre>
</div>

#### Step 7.11.f: DRYing the MessagesOperations module code

There are 2 parts where we can avoid repeating in our code:

`Server Operation` settings instructions:

```ruby
param :acting_user, nils: true
dispatch_to { Hyperloop::Application }
```

and

Read Rails Cache:

```ruby
Rails.cache.fetch('messages') { [] }
```

For the first case, we are going to create a `MessagesBase < hyperloop::ServerOp` class and our 2 `GetMessages` and `Send` class will inherited from it:

```ruby
#/app/hyperloop/operations/messages_operations.rb

module MessagesOperations

  class MessagesBase < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }
  end
  

  class GetMessages < MessagesBase
    outbound :messages

    step { params.messages = Rails.cache.fetch('messages') { [] } }
  end

  class Send < MessagesBase
    param :message

    step do
      params.message = {
        message: params.message
      }
      newcachedmessages = Rails.cache.fetch('messages') { [] } << params.message
      Rails.cache.write('messages', newcachedmessages)
    end
  end

end
```

For the second case we are going to create a method:

```ruby
#/app/hyperloop/operations/messages_operations.rb

...
def cachedmessages
  Rails.cache.fetch('messages') { [] }
end
...

```

#### Step 7.11.g: The final DRYed MessagesOperations module code

<div class="togglecode" 
  data-heading="Step 7.11.g MessageOperations module" 
  data-rows=16
  data-top-level-component="MessageOperations7.11.g">

<pre>
#/app/hyperloop/operations/messages_operations.rb

module MessagesOperations

  class MessagesBase < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    def cachedmessages
      Rails.cache.fetch('messages') { [] }
    end

  end
  

  class GetMessages < MessagesBase
    outbound :messages

    step { params.messages = cachedmessages }
  end


  class Send < MessagesBase
    param :message

    step do
      params.message = {
        message: params.message
      }
      newcachedmessages = cachedmessages << params.message
      Rails.cache.write('messages', newcachedmessages)
    end
  end


end

</pre>
</div>

### Step 7.12: Testing the final application

Restart your Rails server. Refresh your `localhost:3000` page.
And you can try to send messages, they should be displayed on your page.
You can also try the push notifications mechanism by opening your app in another browser.


You can find the complete source code of this tutorial here: [Hyperloop with Rails Helloworld app](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld)

Hope you have been Hyperloop-ed !

<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>