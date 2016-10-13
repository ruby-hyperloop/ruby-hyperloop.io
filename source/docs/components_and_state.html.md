---
title: Docs
---
## Components and State

- [Using State](#using-state)
- [Multiple Components](#multiple-components)
- [Reusable Components](#reusable-components)
- [Param Validation](#param-validation)
- [Default Param Values](#default-param-values)
- [Params of type Proc](#params-of-type-proc)
- [Other Params](#other-params)
- [Mixins and Inheritance](#mixins-and-inheritance)

### Using State

#### A Simple Example

```ruby
class LikeButton < React::Component::Base
  render do
    para do
      "You #{state.liked ? 'like' : 'haven\'t liked'} this. Click to toggle."
    end.on(:click) do
      state.liked! !state.liked
    end
  end
end

Element['#container'].render do
  LikeButton()
end
```

[Try It Out](http://goo.gl/fWUOOe)

### Components are Just State Machines

React thinks of UIs as simple state machines. By thinking of a UI as being in various states and rendering those states, it's easy to keep your UI consistent.

In React, you simply update a component's state, and then the new UI will be rendered on this new state. React takes care of updating the DOM for you in the most efficient way.

### How State Works

Whenever a state variable changes you invoke the corresponding state variable name followed by a "!" method.  For example `state.liked! !state.like` *gets* the current value of like, toggles it, and then *updates* it.  This in turn causes the component to be rerendered. For more details on how this works, and the full syntax of the update method see [the component API reference](#top-level-api)

### What Components Should Have State?

Most of your components should simply take some params and render based on their value. However, sometimes you need to respond to user input, a server request or the passage of time. For this you use state.

**Try to keep as many of your components as possible stateless.** By doing this you'll isolate the state to its most logical place and minimize redundancy, making it easier to reason about your application.

A common pattern is to create several stateless components that just render data, and have a stateful component above them in the hierarchy that passes its state to its children via `params`. The stateful component encapsulates all of the interaction logic, while the stateless components take care of rendering data in a declarative way.

### What *Should* Go in State?

**State should contain data that a component's event handlers, timers, or http requests may change and trigger a UI update.**

When building a stateful component, think about the minimal possible representation of its state, and only store those properties in `state`.  Add to your class methods to compute higher level values from your state variables.  Avoid adding redundant or computed values as state variables as
these values must then be kept in sync whenever state changes.

### What *Shouldn't* Go in State?

`state` should only contain the minimal amount of data needed to represent your UI's state. As such, it should not contain:

* **Computed data:** Don't worry about precomputing values based on state — it's easier to ensure that your UI is consistent if you do all computation during rendering.  For example, if you have an array of list items in state and you want to render the count as a string, simply render `"#{state.list_items.length} list items'` in your `render` method rather than storing the count as another state.
* **Data that does not effect rendering:** For example handles on timers, that need to be cleaned up when a component unmounts should go
in plain old instance variables.

## Multiple Components

So far, we've looked at how to write a single component to display data and handle user input. Next let's examine one of React's finest features: composability.

### Motivation: Separation of Concerns

By building modular components that reuse other components with well-defined interfaces, you get much of the same benefits that you get by using functions or classes. Specifically you can *separate the different concerns* of your app however you please simply by building new components. By building a custom component library for your application, you are expressing your UI in a way that best fits your domain.

### Composition Example

Let's create a simple Avatar component which shows a profile picture and username using the Facebook Graph API.

```ruby
class Avatar < React::Component::Base
  param :user_name
  def render
    div do
      ProfilePic  user_name: params.user_name
      ProfileLink user_name: params.user_name
    end
  end
end

class ProfilePic < React::Component::Base
  param :user_name
  def render
    img src: "https://graph.facebook.com/#{params.user_name}/picture"
  end
end

class ProfileLink < React::Component::Base
  param :user_name
  def render
    a href: "https://www.facebook.com/#{params.user_name}" do
      params.user_name
    end
  end
end

Element['#container'].render do
  Avatar user_name: "pwh"
end
```

### Ownership

In the above example, instances of `Avatar` *own* instances of `ProfilePic` and `ProfileLink`. In React, **an owner is the component that sets the `params` of other components**. More formally, if a component `X` is created in component `Y`'s `render` method, it is said that `X` is *owned by* `Y`. As discussed earlier, a component cannot mutate its `params` — they are always consistent with what its owner sets them to. This fundamental invariant leads to UIs that are guaranteed to be consistent.

It's important to draw a distinction between the owner-ownee relationship and the parent-child relationship. The owner-ownee relationship is specific to React, while the parent-child relationship is simply the one you know and love from the DOM. In the example above, `Avatar` owns the `div`, `ProfilePic` and `ProfileLink` instances, and `div` is the **parent** (but not owner) of the `ProfilePic` and `ProfileLink` instances.

### Children

When you create a React component instance, you can include additional React components or JavaScript expressions between the opening and closing tags like this:

```ruby
Parent { Child() }
```

`Parent` can iterate over its children by accessing its `children` method.

### Child Reconciliation

**Reconciliation is the process by which React updates the DOM with each new render pass.** In general, children are reconciled according to the order in which they are rendered. For example, suppose we have the following render method displaying a list of items.  On each pass
the items will be completely rerendered:

```ruby
def render
  params.items.each do |item|
    para do
      item[:text]
    endt
  end
end
```

What if the first time items was `[{text: "foo"}, {text: "bar"}]`, and the second time items was `[{text: "bar"}]`?
Intuitively, the paragraph `<p>foo</p>` was removed. Instead, React will reconcile the DOM by changing the text content of the first child and destroying the last child. React reconciles according to the *order* of the children.

### Stateful Children

For most components, this is not a big deal. However, for stateful components that maintain data in `state` across render passes, this can be very problematic.

In most cases, this can be sidestepped by hiding elements based on some property change:

```ruby
def render
  state.items.each do |item|
    para(style: {display: item[:some_property] == "some state" ? :block : :none}) do
      item[:text]
    end
  end
end
```

### Dynamic Children

The situation gets more complicated when the children are shuffled around (as in search results) or if new components are added onto the front of the list (as in streams). In these cases where the identity and state of each child must be maintained across render passes, you can uniquely identify each child by assigning it a `key`:

```ruby
  param :results, type: [Hash] # each result is a hash of the form {id: ..., text: ....}
  def render
    ol do
      params.results.each do |result|
        li(key: result[:id]) { result[:text] }
      end
    end
  end
```

When React reconciles the keyed children, it will ensure that any child with `key` will be reordered (instead of clobbered) or destroyed (instead of reused).

The `key` should *always* be supplied directly to the components in the array, not to the container HTML child of each component in the array:

```ruby
  # WRONG!
class ListItemWrapper < React::Component::Base
  param :data
  def render
    li(key: params.data[:id]) { params.data[:text] }
  end
end    
class MyComponent < React::Component::Base
  param :results
  def render
    ul do
      params.result.each do |result|
        ListItemWrapper data: result
      end
    end
  end
end
```
```ruby
  # correct
class ListItemWrapper < React::Component::Base
  param :data
  def render
    li{ params.data[:text] }
  end
end    
class MyComponent < React::Component::Base
  param :results
  def render
    ul do
      params.result.each do |result|
        ListItemWrapper key: result[:id], data: result
      end
    end
  end
end
```

### Data Flow

In React, data flows from owner to owned component through the params as discussed above. This is effectively one-way data binding: owners bind their owned component's param to some value the owner has computed based on its `params` or `state`. Since this process happens recursively, data changes are automatically reflected everywhere they are used.

## Reusable Components

When designing interfaces, break down the common design elements (buttons, form fields, layout components, etc.) into reusable components with well-defined interfaces. That way, the next time you need to build some UI, you can write much less code. This means faster development time, fewer bugs, and fewer bytes down the wire.

## Param Validation

As your app grows it's helpful to ensure that your components are used correctly. We do this by allowing you to specify the expected ruby class of your parameters. When an invalid value is provided for a param, a warning will be shown in the JavaScript console. Note that for performance reasons type checking is only done in development mode. Here is an example showing typical type specifications:

```ruby
class ManyParams < React::Component::Base
  param :an_array,         type: [] # or type: Array
  param :a_string,         type: String
  param :array_of_strings, type: [String]
  param :a_hash,           type: Hash
  param :some_class,       type: SomeClass # works with any class
  param :a_string_or_nil,  type: String, allow_nil: true
end
```

Note that if the param can be nil, add `allow_nil: true` to the specification.

## Default Param Values

React lets you define default values for your `params`:

```ruby
class ManyParams < React::Component::Base
  param :an_optional_param, default: "hello", type: String, allow_nil: true
```

If no value is provided for `:an_optional_param` it will be given the value `"hello"`

## Params of type Proc

A Ruby `Proc` can be passed to a component like any other object.  The `param` macro treats params declared as type `Proc` specially, and will automatically call the proc when the param name is used on the params method.

```ruby
param :all_done, type: Proc
...
  # typically in an event handler
params.all_done(data) # instead of params.all_done.call(data)
```

Proc params can be optional, using the `default: nil` and `allow_nil: true` options.  Invoking a nil proc param will do nothing.  This is handy for allowing optional callbacks.

## Other Params

A common type of React component is one that extends a basic HTML element in a simple way. Often you'll want to copy any HTML attributes passed to your component to the underlying HTML element.

To do this use the `collect_other_params_as` macro which will gather all the params you did not declare into a hash. Then you can pass this hash on to the child component

```ruby
class CheckLink < React::Component::Base
  collect_other_params_as :attributes
  def render
    # we just pass along any incoming attributes
    a(attributes) { '√ '.span; children.each &:render }
  end
end

Element['#container'].render { CheckLink(href: "/checked.html") { "Click here!" }}
```
[Try It Out](http://goo.gl/ZG4ZJg)

Note: `collect_other_params_as` builds a hash, so you can merge other data in or even delete elements out as needed.



## Mixins and Inheritance

Ruby has a rich set of mechanisms enabling code reuse, and Reactrb is intended to be a team player in your Ruby application.  Components can be subclassed, and they can include (or mixin) other modules.  You can also create a
component by including `React::Component` which allows a class to inherit from some other non-react class, and then mixin the React DSL.

```ruby
  # make a SuperFoo react component class
  class Foo < SuperFoo
    include React::Component
  end
```

One common use case is a component wanting to update itself on a time interval. It's easy to use the kernel method `every`, but it's important to cancel your interval when you don't need it anymore to save memory. React provides [lifecycle methods](/docs/working-with-the-browser.html#component-lifecycle) that let you know when a component is about to be created or destroyed. Let's create a simple mixin that uses these methods to provide a React friendly `every` function that will automatically get cleaned up when your component is destroyed.

```ruby
module ReactInterval

  def self.included(base)
    base.before_mount do
      @intervals = []
    end

    base.before_unmount do
      @intervals.each(&:stop)
    end
  end

  def every(seconds, &block)
    Kernel.every(seconds, &block).tap { |i| @intervals << i }
  end
end

class TickTock < React::Component::Base
  include ReactInterval
  before_mount do
    state.seconds! 0
  end
  after_mount do
    every(1) { state.seconds! state.seconds+1}
  end
  def render
    "React has been running for #{state.seconds} seconds".para
  end
end
```

[Try It Out](http://goo.gl/C4IJu0)

Notice that TickTock effectively has two before_mount callbacks, one that is called to initialize the `@intervals` array and another to initialize `state.seconds`
