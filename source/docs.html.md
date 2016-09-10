# Docs

## DSL Overview

The Reactrb DSL (Domain Specific Language) is a set of class and instance methods that are used to describe your React components.

The DSL has the following major areas:  

+ The `React::Component::Base` class and the equivilent `React::Component` mixin.
+ Class methods or *macros* that describe component class level behaviors.
+ The three data accessors methods: `params`, `state`, and `children`.
+ The tag and component rendering methods.
+ Event handlers.
+ Miscellaneous methods.

To understand the DSL we will walk through an example that will cover each of these areas in detail.

```ruby
class Clock < React::Component::Base

  param initial_mode: 12

  before_mount do
    state.mode! params.initial_mode
  end

  after_mount do
    @timer = every(60) { force_update! }
  end

  before_unmount do
    @timer.stop
  end

  FORMATS = {
    12 => "%a, %e %b %Y %I:%M %p",
    24 => "%a, %e %b %Y %H:%M"
    }

  render do
    div(class: :time) do
      Time.now.strftime(FORMATS[state.mode]).span
      select(style: {"margin-left" => 20}, value: state.mode)  do
        option(value: 12) { "12 Hour Clock" }
        option(value: 24) { "24 Hour Clock" }
      end.on(:change) do |e|
        state.mode!(e.target.value.to_i)
      end
    end
  end
end

Element['#container'].render do
  Clock(initial_mode: 12)
end
```

[Try It Out](http://goo.gl/zN8i9B)

### React::Component::Base

Component classes can be be created by inheriting from `React::Component::Base`.

```ruby
class Clock < React::Component::Base
...
end
```

You may also create a component class by mixing in the `React::Component` module:

```ruby
class Clock2
  include React::Component
  ...
end
```

### Macros (Class Methods)

Macros specify class wide behaviors.  In our example we use the five most common macros.

```ruby
class Clock < React::Component::Base
  param ...
  before_mount ...
  after_mount ...
  before_unmount ...
  render ...
  ...
end
```  

The `param` macro describes the parameters the component expects.

The `before_mount` macro defines code to be run (a callback) when a component instance is first initialized.

The `after_mount` macro likewise runs after the instance has completed initialization, and is visible in the DOM.

The `before_unmount` macro provides any cleanup actions before the instance is destroyed.

The `render` macro defines the render method.

The available macros are: `render, param, export_state, before_mount, after_mount, before_receive_props, before_update, after_update, before_unmount`

### Data Accessor Methods

The three data accessor methods - `params, state, and children` are instance methods that give access to a component's React specific instance data.

The `params` method gives (read only) access to each of the params passed to this instance, the `state` method allows state variables to be read and written, and `children` returns an enumerator of a component's children.

In our example we see

```ruby
  before_mount do
    state.mode! params.mode
  end
```

`params.mode` will return the value of the `mode` parameter passed to this instance, and `state.mode!` initializes (or updates) the `mode` state variable.  State variables are like *reactive* instance variables.  They can only be changed using the "!" method, and when they change they will cause a rerender.  

More on the details of these methods can be found in the [Component API](/component-api.html) section.

### Tag and Component Rendering

```ruby
  ...
    div(class: :time) do
      ...
    end
  ...
```

HTML such as `div, a, select, option` etc. each have a corresponding instance method that will render that tag.  For all the tags the
method call looks like this:

```ruby
tag_name(attribute1 => value1, attribute2 => value2 ...) do
  ...nested tags...
end
```

Each key-value pair in the parameter block is passed down as an attribute to the tag as you would expect, with the exception of the `style` attribute, which takes a hash that is translated to the corresponding style string.

The same rules apply for application defined components, except that the class constant is used to reference the component.

```ruby
Clock(mode: 12)
```

**Using Strings**

Strings are treated specially as follows:  

If a render method or a nested tag block returns a string, the string is automatically wrapped in a `<span>` tag.

The code `span { "hello" }` can be shortened to `"hello".span`, likewise for `td, para, td, th` tags.

`"some string".br` generates `<span>some string<span><br/>`


```ruby
Time.now.strftime(FORMATS[state.mode]).span  # generates <span>...current time formatted...</span>
...
  option(value: 12) { "12 Hour Clock" }      # generates <option value=12><span>12 Hour Clock</span></option>
```

**HAML style class names**

Any tag or component name can be followed by `.class_name` HAML style.

```ruby
div.class1.class2
# short for
div(class: "class1 class2")
```

Note that underscores are translated to dashes.  So `.foo_bar` will add the `foo-bar` class to the tag.  If you need to use an underscore in a class name use a double underscore which will be translated to a single underscore in the class name.

### Event Handlers

Event Handlers are attached to tags and components using the `on` method.

```ruby
select ... do
  ...
end.on(:change) do |e|
  state.mode!(e.target.value.to_i)
end
```

The `on` method takes the event name symbol (note that `onClick` becomes `:click`) and the block is passed the React.js event object.

Event handlers can be chained like so

```ruby
input ... do
  ...
  end.on(:key_up) do |e|
  ...
  end.on(:change) do |e|
  ...
end
```

### Miscellaneous Methods

`force_update!` is a component instance method that causes the component to re-rerender.

`as_node` can be attached to a component or tag, and removes the element from the rendering buffer and returns it.   This is useful when you need store an element in some data structure, or passing to a native JS component.  When passing an element to another reactrb component `.as_node` will be automatically applied so you normally don't need it.  

`render` can be applied to the objects returned by `as_node` and `children` to actually render the node.

```ruby
class Test < React::Component::Base
  param :node
  render do
    div do
      children.each do |child|
        params.node.render
        child.render
      end
      params.node.render
    end
  end
end

Element['#container'].render do
  Test(node: "foo".span) do
  # equivilent to Test(node: "foo".span.as_node)...
    div { "hello"}
    div { "goodby" }
  end
end
```

[Try It Out](http://goo.gl/J6m0PN)

### Ruby and Reactrb

A key design goal of the DSL is to make it work seamlessly with the rest of Ruby.  Notice in the above example, the use of constant declaration (`FORMATS`), regular instance variables (`@timer`), and other non-react methods like `every` (an Opal Browser method).  

Component classes can be organized like any other class into a logical module hierarchy or even subclassed.

Likewise the render method can invoke other methods to compute values or even internally build tags.

## DSL Gotchas

There are few gotchas with the DSL you should be aware of:

React has implemented a browser-independent events and DOM system for performance and cross-browser compatibility reasons. We took the opportunity to clean up a few rough edges in browser DOM implementations.

Todo: check links below

* All DOM properties and attributes (including event handlers) should be snake_cased to be consistent with standard Ruby style. We intentionally break with the spec here since the spec is inconsistent. **However**, `data-*` and `aria-*` attributes [conform to the specs](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes#data-*) and should be lower-cased only.
* The `style` attribute accepts a Hash with camelCased properties rather than a CSS string. This  is more efficient, and prevents XSS security holes.
* All event objects conform to the W3C spec, and all events (including submit) bubble correctly per the W3C spec. See [Event System](/docs/events.html) for more details.
* The `onChange` event (`on(:change)`) behaves as you would expect it to: whenever a form field is changed this event is fired rather than inconsistently on blur. We intentionally break from existing browser behavior because `onChange` is a misnomer for its behavior and React relies on this event to react to user input in real time. See [Forms](/docs/forms.html) for more details.
* Form input attributes such as `value` and `checked`, as well as `textarea`. [More here](/docs/forms.html).

### HTML Entities

If you want to display an HTML entity within dynamic content, you will run into double escaping issues as React.js escapes all the strings you are displaying in order to prevent a wide range of XSS attacks by default.

```ruby
# Bad: It displays "First &middot; Second"
div {'First &middot; Second' }
```

To workaround this you have to insert raw HTML.

```ruby
div(dangerously_set_inner_HTML: { __html: "First &middot; Second"})
```

### Custom HTML Attributes

If you pass properties to native HTML elements that do not exist in the HTML specification, React will not render them. If you want to use a custom attribute, you should prefix it with `data-`.

```ruby
div("data-custom-attribute" => "foo")
```

[Web Accessibility](http://www.w3.org/WAI/intro/aria) attributes starting with `aria-` will be rendered properly.

```ruby
div("aria-hidden" => true)
```

### Invoking Application Components

When invoking a custom component you must have a (possibly empty) parameter list or (possibly empty) block.  This is not necessary
with standard html tags.

```ruby
MyCustomComponent()  # okay
MyCustomComponent {} # okay
MyCustomComponent    # breaks
br                   # okay
```

## State and Event Handelers

### A Simple Example

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

### Event Handling and Synthetic Events

With React you attach event handlers to elements using the `on` method. React ensures that all events behave identically in IE8 and above by implementing a synthetic event system. That is, React knows how to bubble and capture events according to the spec, and the events passed to your event handler are guaranteed to be consistent with [the W3C spec](http://www.w3.org/TR/DOM-Level-3-Events/), regardless of which browser you're using.

### Under the Hood: Event Delegation

React doesn't actually attach event handlers to the nodes themselves. When React starts up, it starts listening for all events at the top level using a single event listener. When a component is mounted or unmounted, the event handlers are simply added or removed from an internal mapping. When an event occurs, React knows how to dispatch it using this mapping. When there are no event handlers left in the mapping, React's event handlers are simple no-ops. To learn more about why this is fast, see [David Walsh's excellent blog post](http://davidwalsh.name/event-delegate).

### Components are Just State Machines

React thinks of UIs as simple state machines. By thinking of a UI as being in various states and rendering those states, it's easy to keep your UI consistent.

In React, you simply update a component's state, and then the new UI will be rendered on this new state. React takes care of updating the DOM for you in the most efficient way.

### How State Works

ToDo: check link below

Whenever a state variable changes you invoke the corresponding state variable name followed by a "!" method.  For example `state.liked! !state.like` *gets* the current value of like, toggles it, and then *updates* it.  This in turn causes the component to be rerendered. For more details on how this works, and the full syntax of the update method see [the component API reference]( docs/component-api.html#the-state-instance-method)

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

## Params of type React::Observable

`React::Observable` objects work very similar to state variables.  Any render method that accesses an observable value will be re-rendered if that value changes, and you can update the value (causing a rerender) using the param name followed by a "!".

Observable's are used to set up two (or even n) way linkages between components.  See the [React::Observable](tbd) section for details.

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

```Ruby
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
