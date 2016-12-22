---
title: Flux Store Tutorial
---
## Implementing a Flux Store

Let's say, for example, that you have deeply nested components where the inner child component needs to tell the outermost component to reload its JSON and re-render. You could use callbacks between components for children to speak to their parent there is a better way to do this using a Flux pattern.

It is very easy to implement a Flux store pattern in Hyperloop.

In your top level component use the `export_state` directive to export the state outside the component.

This does two things:
* It makes the state variable a class level instance variable, so all instances of that top level component (but you probably will only have one) share that state variable.
* It makes the instance variable accessible outside the class.

For example:

```ruby
class MyApp < React::Component::Base

  export_state :store

  before_mount do
    MyApp.store!({})
  end

  def render
    div do
      MyApp.store.each do |name, value|
        DisplayItem(name: name, value: value)
      end
      AddItem()
    end
  end
end

class DisplayItem < React::Component::Base
  param :name
  param :value
  def render
    div do
      "#{params.name}: #{params.value}".span
      button { "delete!"}.on(:click) { MyApp.store!.delete(params.name) }
    end
  end
end

class AddItem < React::Component::Base
  def render
    div do
      input.new_name
      input.new_value
      button { "add" }.on(:click) do
        MyApp.store![Element[".new-name"].value] = Element[".new-value"].value
      end
    end
  end
end
  ```

Try it here: http://goo.gl/ul1AZM

As you see store acts just like state variable. You update it just like a state variable by adding the bang (!) at the end of the name, which will cause a rerender of any component depending on the value of store.

Let's clean this up just a little bit. What we are going to do is hide the specifics of how we represent our store.

```ruby
class MyApp < React::Component::Base

  export_state :store

  def self.add_item(key, value)
    store![key] = value
  end

  def self.delete_item(key)
    store!.delete(key)
  end

  before_mount do
    MyApp.store!({})
  end

  def render
    div do
      MyApp.store.each do |name, value|
        DisplayItem(name: name, value: value)
      end
      AddItem()
    end
  end
end

class DisplayItem < React::Component::Base
  param :name
  param :value
  def render
    div do
      "#{params.name}: #{params.value}".span
      button { "delete!"}.on(:click) { MyApp.delete_item(params.name) }
    end
  end
end

class AddItem < React::Component::Base
  def render
    div do
      input.new_name
      input.new_value
      button { "add" }.on(:click) do
        MyApp.add_item(
          Element[".new-name"].value,
          Element[".new-value"].value
        )
      end
    end
  end
end
```

Try it here: http://goo.gl/7iMVbe

Let's separate out the store completely from the top level App:

```ruby
class Store < React::Component::Base

  export_state :store

  class << self

    def add_item(key, value)
      store![key] = value
    end

    def delete_item(key)
      store!.delete(key)
    end

    def each(&block)
      store.each &block
    end

    def init
      store!({})
    end
  end

end


class MyApp < React::Component::Base

  before_mount do
    Store.init
  end

  def render
    div do
      Store.each do |name, value|
        DisplayItem(name: name, value: value)
      end
      AddItem()
    end
  end
end

class DisplayItem < React::Component::Base
  param :name
  param :value
  def render
    div do
      "#{params.name}: #{params.value}".span
      button { "delete!"}.on(:click) { Store.delete_item(params.name) }
    end
  end
end

class AddItem < React::Component::Base
  def render
    div do
      input.new_name
      input.new_value
      button { "add" }.on(:click) do
        Store.add_item(
          Element[".new-name"].value,
          Element[".new-value"].value
        )
      end
    end
  end
end
```

Try it here: http://bit.ly/25Tzppj

Two things still bother me here:

* Having store inheriting from React::Component::Base is misleading (its not really a component)
* Making MyApp responsible for initializing the store seems backwards.

We can fix both problems up as follows:

```ruby
class Store

  include React::Component
  include React::IsomorphicHelpers

  export_state :store

  class << self

    def add_item(key, value)
      store![key] = value
    end

    def delete_item(key)
      store!.delete(key)
    end

    def each(&block)
      store.each &block
    end

    def init
      store!({})
    end
  end

  before_first_mount do
    Store.init
  end

end

class MyApp < React::Component::Base

  def render
    div do
      Store.each do |name, value|
        DisplayItem(name: name, value: value)
      end
      AddItem()
    end
  end
end
  ```

There is no functional difference in including React::Component, but I think it makes things clearer. React::IsomorphicHelpers adds a number of methods to a class including the one we need: `before_first_mount` which will run when page first loads, right before the first component anywhere on the page mounts.

Try it here: http://bit.ly/1tj4CnC

Just using the basic features built into Hyperloop you can easily build a flux store!

As you can see flux is simply a programming pattern, that keeps your code clean. Data flows down to the leaf components, which will call methods on a store as external events occur. Updating the store, triggers rerendering of any components reading that data, which will cascade down to any lower level components that have changed as a result.

One thing that you may wonder about is efficiency... so let's add output info to the console whenever we re-render DisplayItem:

```ruby
class DisplayItem < React::Component::Base
  param :name
  param :value
  def render
    puts "rerendering #{params.name}, #{params.value}"
    div do
      "#{params.name}: #{params.value}".span
      button { "delete!"}.on(:click) { Store.delete_item(params.name) }
    end
  end
end
  ```

Try it here: http://bit.ly/25TDqtU

Open up the javascript console, and add at least 3 items, then delete a middle item.

You will notice that adding an item only renders the new row, however when you delete a middle item all the rows below the item you deleted get re-rendered. This is not due to the flux pattern, but is a problem that react calls reconciliation, and there is a simple solution. In cases where you have lists of items being shuffled around, react can be given a "key" for each item, and during reconciliation it will use the keys to match up items before and after. https://facebook.github.io/react/docs/reconciliation.html

So all we need to do is add a unique key to each DisplayItem. In our simple example the "name" can act as a key, since we know its going to be unique. In a real implementation you would want the store to be responsible for this, and have a key method on each object in a list (perhaps?). Notice that "key" is a reserved param. It does not get passed into the component but is intercepted by react and used internally.

```ruby
class MyApp < React::Component::Base
  def render
    div do
      Store.each do |name, value|
        DisplayItem(name: name, value: value, key: name)
      end
      AddItem()
    end
  end
end
```

Try it here: http://bit.ly/1UmHLBU

Make sure you see [HyperMesh](https://github.com/ruby-hyperloop/hyper-mesh) which is simply a store like this that contains proxies to all your server models!
