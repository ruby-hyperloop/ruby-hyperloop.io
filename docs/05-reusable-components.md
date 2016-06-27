---
id: reusable-components
title: Reusable Components
permalink: reusable-components.html
prev: multiple-components.html
next: transferring-props.html
---

When designing interfaces, break down the common design elements (buttons, form fields, layout components, etc.) into reusable components with well-defined interfaces. That way, the next time you need to build some UI, you can write much less code. This means faster development time, fewer bugs, and fewer bytes down the wire.

## Param Validation

As your app grows it's helpful to ensure that your components are used correctly. We do this by allowing you to specify the expected ruby class of your parameters. When an invalid value is provided for a param, a warning will be shown in the JavaScript console. Note that for performance reasons type checking is only done in development mode. Here is an example showing typical type specifications:

```Ruby
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

```Ruby

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
