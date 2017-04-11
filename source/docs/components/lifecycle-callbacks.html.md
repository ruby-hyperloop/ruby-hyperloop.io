---
title: Components
---
## Lifecycle Callbacks

A component may define callbacks for each phase of the components lifecycle:

* `before_mount`
* `render`
* `after_mount`
* `before_receive_props`
* `before_update`
* `after_update`
* `before_unmount`

All the callback macros may take a block or the name of an instance method to be called.

```ruby
class AComponent < Hyperloop::Component
  before_mount do
    # initialize stuff here
  end
  before_unmount :cleanup  # call the cleanup method before unmounting
  ...
end
```

Except for the render callback, multiple callbacks may be defined for each lifecycle phase, and will be executed in the order defined, and from most deeply nested subclass outwards.

Details on the component lifecycle is described [here](docs/component-specs.html)

### The `param` macro

Within a React Component the `param` macro is used to define the parameter signature of the component.  You can think of params as
the values that would normally be sent to the instance's `initialize` method, but with the difference that a React Component gets new parameters when it is rerendered.  

The param macro has the following syntax:

```ruby
param symbol, ...options... # or
param symbol => default_value, ...options...
```

Available options are `:default_value => ...any value...` and `:type => ...class_spec...`
where class_spec is either a class name, or `[]` (shorthand for Array), or `[ClassName]` (meaning array of `ClassName`.)

Note that the default value can be specied either as the hash value of the symbol, or explicitly using the `:default_value` key.

Examples:

```ruby
param :foo # declares that we must be provided with a parameter foo when the component is instantiated or re-rerendered.
param :foo => "some default"        # declares that foo is optional, and if not present the value "some default" will be used.
param foo: "some default"           # same as above using ruby 1.9 JSON style syntax
param :foo, default: "some default" # same as above but uses explicit default key
param :foo, type: String            # foo is required and must be of type String
param :foo, type: [String]          # foo is required and must be an array of Strings
param foo: [], type: [String]       # foo must be an array of strings, and has a default value of the empty array.
```

#### Accessing param values

The component instance method `params` gives access to all declared params.  So for example

```ruby
class Hello < Hyperloop::Component
  param visitor: "World", type: String
  render
    "Hello #{params.visitor}"
  end
end
```

#### Params of type `Proc`

A param of type proc (i.e. `param :update, type: Proc`) gets special treatment that will directly
call the proc when the param is accessed.

```ruby
class Alarm < Hyperloop::Component
  param :at, type: Time
  param :notify, type: Proc
  after_mount do
    @clock = every(1) do
      if Time.now > params.at
        params.notify
        @clock.stop
      end
      force_update!
    end
  end
  def render
    "#{Time.now}"
  end
end
```

If for whatever reason you need to get the actual proc instead of calling it use `params.method(*symbol name of method*)`

### The `state` instance method

React state variables are *reactive* component instance variables that cause rerendering when they change.

State variables are accessed via the `state` instance method which works like the `params` method. Like normal instance variables, state variables are created when they are first accessed, so there is no explicit declaration.  

To access the value of a state variable `foo` you would say `state.foo`.  

To initialize or update a state variable you use its name followed by `!`.  For example `state.foo! []` would initialize `foo` to an empty array.  Unlike the assignment operator, the update method returns the current value (before it is changed.)

Often state variables have complex values with their own internal state, an array for example.  The problem is as you push new values onto the array you are not changing the object pointed to by the state variable, but its internal state.

To handle this use the same "!" suffix with **no** parameter, and then apply any update methods to the resulting value.  The underlying value will be updated, **and** the underlying system will be notified that a state change has occurred.

For example
```ruby
  state.foo! []    # initialize foo (returns nil)
  ...later...
  state.foo! << 12  # push 12 onto foo's array
  ...or...
  state.foo! {}
  state.foo![:house => :boat]
```

The rule is simple:  anytime you are updating a state variable follow it by the "!".

> #### Tell Me How That Works???
>
> A state variables update method (name followed by "!") can optionally accept one parameter.  If a parameter is passed, then the method will 1) save the current value, 2) update the value to the passed parameter, 3) update the underlying react.js state object, 4) return the saved value.

### The `force_update!` method

The `force_update!` instance method causes the component to re-render.  Usually this is not necessary as rendering will occur when state variables change, or new params are passed.  For a good example of using `force_update!` see the `Alarm` component above.  In this case there is no reason to have a state track of the time separately, so we just call `force_update!` every second.

### The `dom_node` method

Returns the dom_node that this component instance is mounted to.  Typically used in the `after_mount` callback to setup linkages to external libraries.

### The `children` method

Along with params components may be passed a block which is used to build the components children.

The instance method `children` returns an enumerable that is used to access the unrendered children of a component.

```ruby
class IndentEachLine < Hyperloop::Component
  param by: 20, type: Integer
  def render
    div do
      children.each_with_index do |child, i|
        child.render(style: {"margin-left" => params.by*i})
      end
    end
  end
end

Element['#container'].render do
  IndentEachLine(by: 100) do
    div {"Line 1"}
    div {"Line 2"}
    div {"Line 3"}
  end
end
```
