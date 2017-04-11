---
title: Components
---
## Components DSL Overview

Hyperloop **Components** are implemented in the **HyperReact Gem**.

The HyperReact DSL (Domain Specific Language) is a set of class and instance methods that are used to describe your React components.

- [React::Component::Base](#react-component-base)
- [Macros (Class Methods)](#macros-class-methods)
- [Data Accessor Methods](#data-accessor-methods)
- [Tag and Component Rendering](#tag-and-component-rendering)
- [Using Strings](#using-strings)
- [HAML style class names](#haml-style-class-names)
- [Event Handlers](#event-handlers)
- [Miscellaneous Methods](#miscellaneous-methods)
- [Ruby and HyperReact](#ruby-and-hyperreact)
- [DSL Gotchas](#dsl-gotchas)

The DSL has the following major areas:  

+ The `React::Component::Base` class and the equivilent `React::Component` mixin.
+ Class methods or *macros* that describe component class level behaviors.
+ The four data accessors methods: `params`, `state`, `mutate`, and `children`.
+ The tag and component rendering methods.
+ Event handlers.
+ Miscellaneous methods.

To understand the DSL we will walk through an example that will cover each of these areas in detail.

```ruby
class Clock < React::Component::Base

  param initial_mode: 12

  before_mount do
    mutate.mode params.initial_mode
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
        mutate.mode(e.target.value.to_i)
      end
    end
  end
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

The `React` module is the name space for all the React classes and modules.  

React components classes either include `React::Component` or are subclasses of `React::Component::Base`.  

```ruby
class Component < React::Component::Base
end

# if subclassing is inappropriate, you can mixin instead
class AnotherComponent
  include React::Component
end
```

At a minimum every component class must define a `render` method which returns **one single** child element. That child may in turn have an arbitrarily deep structure.

```ruby
class Component < React::Component::Base
  def render
    div # render an empty div
  end
end
```

You may also use the `render` macro to define the render method, which has some styling advantages, but is functionally equivilent.

```ruby
class Component < React::Component::Base
  render do
    div # render an empty div
  end
end
```


To render a component, you reference its class name in the DSL as a method call.  This creates a new instance, passes any parameters proceeds with the component lifecycle.  

```ruby
class AnotherComponent < React::Component::Base
  def render
    Component() # ruby syntax requires either () or {} following the class name
  end
end
```

Note that you should never redefine the `new` or `initialize` methods, or call them directly.  The equivilent of `initialize` is the `before_mount` callback.  


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

The available macros are: `render, param, state, mutate, before_mount, after_mount, before_receive_props, before_update, after_update, before_unmount`

### Data Accessor Methods

The four data accessor methods - `params, state, mutate, and children` are instance methods that give access to a component's React specific instance data.

The `params` method gives (read only) access to each of the params passed to this instance, the `state` method allows state variables to be read and written, and `children` returns an enumerator of a component's children.

In our example we see

```ruby
  before_mount do
    mutate.mode params.mode
  end
```

`params.mode` will return the value of the `mode` parameter passed to this instance, and `mutate.mode` initializes (or updates) the `mode` state variable.  State variables are like *reactive* instance variables.  They can only be changed using the `mutate` method, and when they change they will cause a rerender.  

More on the details of these methods can be found in the [Component API](#top-level-api) section.

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

### Using Strings

Strings are treated specially as follows:  

If a render method or a nested tag block returns a string, the string is automatically wrapped in a `<span>` tag.

The code `span { "hello" }` can be shortened to `"hello".span`, likewise for `td, para, td, th` tags.

`"some string".br` generates `<span>some string<span><br/>`


```ruby
Time.now.strftime(FORMATS[state.mode]).span  # generates <span>...current time formatted...</span>
...
  option(value: 12) { "12 Hour Clock" }      # generates <option value=12><span>12 Hour Clock</span></option>
```

### HAML style class names

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
  mutate.mode(e.target.value.to_i)
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

`as_node` can be attached to a component or tag, and removes the element from the rendering buffer and returns it.   This is useful when you need store an element in some data structure, or passing to a native JS component.  When passing an element to another HyperReact component `.as_node` will be automatically applied so you normally don't need it.  

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
```

[Try It Out](http://goo.gl/J6m0PN)

### Ruby and HyperReact

A key design goal of the DSL is to make it work seamlessly with the rest of Ruby.  Notice in the above example, the use of constant declaration (`FORMATS`), regular instance variables (`@timer`), and other non-react methods like `every` (an Opal Browser method).  

Component classes can be organized like any other class into a logical module hierarchy or even subclassed.

Likewise the render method can invoke other methods to compute values or even internally build tags.

### DSL Gotchas

There are few gotchas with the DSL you should be aware of:

React has implemented a browser-independent events and DOM system for performance and cross-browser compatibility reasons. We took the opportunity to clean up a few rough edges in browser DOM implementations.

* All DOM properties and attributes (including event handlers) should be snake_cased to be consistent with standard Ruby style. We intentionally break with the spec here since the spec is inconsistent. **However**, `data-*` and `aria-*` attributes [conform to the specs](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes#data-*) and should be lower-cased only.
* The `style` attribute accepts a Hash with camelCased properties rather than a CSS string. This  is more efficient, and prevents XSS security holes.
* All event objects conform to the W3C spec, and all events (including submit) bubble correctly per the W3C spec. See [Event System](#event-handling-and-synthetic-events) for more details.
* The `onChange` event (`on(:change)`) behaves as you would expect it to: whenever a form field is changed this event is fired rather than inconsistently on blur. We intentionally break from existing browser behavior because `onChange` is a misnomer for its behavior and React relies on this event to react to user input in real time.
* Form input attributes such as `value` and `checked`, as well as `textarea`.

#### HTML Entities

If you want to display an HTML entity within dynamic content, you will run into double escaping issues as React.js escapes all the strings you are displaying in order to prevent a wide range of XSS attacks by default.

```ruby
div {'First &middot; Second' }
  # Bad: It displays "First &middot; Second"
```

To workaround this you have to insert raw HTML.

```ruby
div(dangerously_set_inner_HTML: { __html: "First &middot; Second"})
```

#### Custom HTML Attributes

If you pass properties to native HTML elements that do not exist in the HTML specification, React will not render them. If you want to use a custom attribute, you should prefix it with `data-`.

```ruby
div("data-custom-attribute" => "foo")
```

[Web Accessibility](http://www.w3.org/WAI/intro/aria) attributes starting with `aria-` will be rendered properly.

```ruby
div("aria-hidden" => true)
```

#### Invoking Application Components

When invoking a custom component you must have a (possibly empty) parameter list or (possibly empty) block.  This is not necessary
with standard html tags.

```ruby
MyCustomComponent()  # okay
MyCustomComponent {} # okay
MyCustomComponent    # breaks
br                   # okay
```
