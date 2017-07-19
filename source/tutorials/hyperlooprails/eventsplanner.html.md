---
title: Tutorials, Videos & Quickstarts
---

## <i class="flaticon-professor-teaching"></i><span class="bigfirstletter">E</span>vents planner Tutorial

#### Writing this tutorial state : In progress





You can find the complete source code of this tutorial here: [Hyperloop with Rails Event planner app](https://github.com/ruby-hyperloop/hyperloop-rails-eventsplanner)

### Tutorial

To set up your **Hyperloop** environment and continue this tutorial, please first follow the <br><br>
<button type="button" class="btn btn-primary btn-lg btn-hyperlooppink" onclick="location.href='/installation#rorsetup';">Hyperloop installation with Ruby On Rails tutorial</button>

After **Hyperloop** has been installed properly we can go further.


##### Step 1: Creating the controller

```ruby
#app/controllers/home_controller.rb

class HomeController < ApplicationController
  def show
    
  end
end
```

##### Step 2: Creating the view

```erb
#app/views/home/show.html.erb

<%= react_component '::Show', {}, { prerender: false } %>
```

##### Step 3: Creating the route

Add to your `routes.rb` file

```ruby
#config/routes.rb

get 'eventplanner', to: 'home#show' 
```

##### Step 4: Creating the model

Run the Rails model generator:

```
rails g model Planevent
```

And then before you run the migration, let's flesh them out a little so they look like this:

```ruby
# db/migrate/..create_planevents.rb

class CreatePlanevents < ActiveRecord::Migration[5.0]
  def change
    create_table :planevents do |t|
      t.string :planeventtitle
      t.text :description
      t.timestamps
    end
  end
end
```

Now run the migration:

```
rails db:migrate
```

##### Step 5: Making your models accessible to Hyperloop Models

Hyperloop Models needs to 'see' your models because a representation of them gets compiled into JavaScript along with your Hyperloop Components so they are accessible in your client-side code.

Move `app/models/planevent.rb` to `app/hyperloop/models/planevent.rb`

For Rails 5.x only, copy `app/models/application_record.rb` to `app/hypermodel/models/application_record.rb`

##### Step 6: Creating components

To get started, let's create a new component which will display a list of Events:

```ruby
# app/hyperloop/components/show.rb

class Show < Hyperloop::Component

  def render
    DIV do
      PlaneventsList()
    end
  end
  
end
```

Note that to place a HyperReact Components you either need to include ( ) or { }, so planeventsList() or PlaneventsList { } would be valid but just PlaneventsList would not.

Next let's create the PlaneventsList component:

```ruby
#app/hyperloop/components/planeventslist.rb


class PlaneventsList < Hyperloop::Component

  state new_planevent: Hash.new { |h, k| h[k] = '' }

  before_mount do
    # note that this will lazy load posts
    # and only the fields that are needed will be requested
    @planevents = Planevent.all
    @planevent_attributes = Hash[ 'planeventtitle' => 'Event Name', 'description' => 'Description']
  end

  def render
    DIV(class: 'container') do
    	DIV(class: 'row') do
      	new_planevent
      end

      HR

    	DIV(class: 'row') do
    		table_render
    	end

    end
  end

  def table_render

      DIV(class: 'col_md_12') do
        BR
        TABLE(class: "table table-hover") do
          THEAD do
            TR do
              TD(class: 'text_muted small', width: '33%') { "NAME" }
              TD(class: 'text_muted small', width: '33%') { "DESCRIPTION" }
              TD(class: 'text_muted small', width: '33%') { "DATE" }
            end
          end
          TBODY do
            @planevents.reverse.each do |planevent|
              PlaneventsListItem(planevent: planevent)
            end
          end
        end
      end

  end

  def new_planevent

  	@planevent_attributes.each do |attribute, value|

      DIV(class: 'form-group') do
        LABEL() { value } 
        INPUT(value: state.new_planevent[attribute], type: :text,
              class: 'form-control login-input')
          .on(:change) { |e|
            mutate.new_planevent[attribute] = e.target.value
          }
      end
   
    end

    BUTTON(type: :button,
         class: 'btn btn-success btn-block') { 'Create an new event' }
    .on(:click) { save_new_planevent }

  end

  def save_new_planevent

    Planevent.create(state.new_planevent) do |result|
      # note that save is a promise so this code will only run after the save
      # yet react will move onto the code after this (before the save happens)
      alert "unable to save" unless result == true
    end
    state.new_planevent.clear

  end
end

class PlaneventsListItem < Hyperloop::Component
  param :planevent

  def render
  	TR do
      TD(width: '33%') { params.planevent.planeventtitle }
      TD(width: '33%') { params.planevent.description }
      TD(width: '33%') { params.planevent.created_at.to_s }
    end
  end

end

```

<div>
  <p>The <strong>best way</strong> to get help and contribute is to join our Gitter Chat</p>
  <button type="button" class="btn btn-primary btn-lg btn-hyperloopgitter" onclick="location.href='https://gitter.im/ruby-hyperloop/chat';">Gitter Chat</button>
</div>