---
title: Tutorials, Videos & Quickstarts
---


## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">H</span>elloWorld Tutorial

![Screen](https://raw.githubusercontent.com/ruby-hyperloop/hyperloop-js-helloworld/master/hyperloophelloworldscreenshot.png)


You can find the complete source code of this tutorial here: [Hyperloop with Rails Helloworld app](https://github.com/ruby-hyperloop/hyperloop-rails-helloworld)

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the [Hyperloop installation with Ruby On Rails](/installation#rorsetup) tutorial.

After **Hyperloop** has been installed properly we can go further:

##### Step 1: Creating the Helloworld component

Run the hyperloop generator:

```
rails g hyper:component Helloworld
```

You can view the new Component created in `/app/hyperloop/components/`

##### Step 2: Updating Helloworld component code

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


##### Step 3: Creating the controller

Create a `home_controller.rb` file:

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def helloworld
  end
end
```

##### Step 4: Updating the routes.rb file

```ruby
#get 'home/helloworld'
root 'home#helloworld'
``` 

##### Step 5: Creating the helloworld view file:

```ruby
#app/vies/home/helloworld.html.erb

<div class="hyperloophelloword">

  <div>
  	<%= react_component '::Helloworld', {}, { prerender: true } %>
  </div>

</div>
```
