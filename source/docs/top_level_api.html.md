---
title: Docs
---
## Top level API

The `React` module is the name space for all the React classes and modules.  


## React::Component and React::Component::Base

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


**`React.create_element`**

A React Element is a component class, a set of parameters, and a group of children.  When an element is rendered the parameters and used to initialize a new instance of the component.

`React.create_element` creates a new element.  It takes either the component class, or a string (representing a built in tag such as div, or span), the parameters (properties) to be passed to the element, and optionally a block that will be evaluated to build the enclosed children elements

```ruby
React.create_element("div", prop1: "foo", prop2: 12) { para { "hello" }; para { "goodby" } )
  # when rendered will generates <div prop1="foo" prop2="12"><p>hello</p><p>goodby</p></div>
```

**You almost never need to directly call `create_element`, the DSL, Rails, and jQuery interfaces take care of this for you.**

```ruby
    # dsl - creates element and pushes it into the rendering buffer
    MyComponent(...params...) { ...optional children... }

    # dsl - component will NOT be placed in the rendering buffer
    MyComponent(...params...) { ... }.as_node

    # in a rails controller - renders component as the view
    render_component("MyComponent", ...params...)

    # in a rails view helper - renders component into the view (like a partial)
    react_component("MyComponent", ...)

    # from jQuery (Note Element is the Opal jQuery wrapper, not be confused with React::Element)
    Element['#container'].render { MyComponent(...params...) { ...optional children... } }  
```

**`React.is_valid_element?`**

```ruby
is_valid_element?(object)
```

Verifies `object` is a valid react element.  Note that `React::Element` wraps the React.js native class,
`React.is_valid_element?` returns true for both classes unlike `object.is_a? React::Element`

**`React.render`**

```ruby
React.render(element, container) { puts "element rendered" }
```

Render an `element` into the DOM in the supplied `container` and return a [reference](/docs/more-about-refs.html) to the component.

The container can either be a DOM node or a jQuery selector (i.e. Element['#container']) in which case the first element is the container.

If the element was previously rendered into `container`, this will perform an update on it and only mutate the DOM as necessary to reflect the latest React component.

If the optional block is provided, it will be executed after the component is rendered or updated.

> Note:
>
> `React.render()` controls the contents of the container node you pass in. Any existing DOM elements inside are replaced when first called. Later calls use React’s DOM diffing algorithm for efficient updates.
>
> `React.render()` does not modify the container node (only modifies the children of the container). In the future, it may be possible to insert a component to an existing DOM node without overwriting the existing children.


**`React.unmount_component_at_node`**

```ruby
React.unmount_component_at_node(container)
```

Remove a mounted React component from the DOM and clean up its event handlers and state. If no component was mounted in the container, calling this function does nothing. Returns `true` if a component was unmounted and `false` if there was no component to unmount.

**`React.render_to_string`**

```ruby
React.render_to_string(element)
```

Render an element to its initial HTML. This is should only be used on the server for prerendering content. React will return a string containing the HTML. You can use this method to generate HTML on the server and send the markup down on the initial request for faster page loads and to allow search engines to crawl your pages for SEO purposes.

If you call `React.render` on a node that already has this server-rendered markup, React will preserve it and only attach event handlers, allowing you to have a very performant first-load experience.

If you are using rails, then the prerendering functions are automatically performed.  Otherwise you can use `render_to_string` to build your own prerendering system.


**`React.render_to_static_markup`**

```ruby
React.render_to_static_markup(element)
```

Similar to `render_to_string`, except this doesn't create extra DOM attributes such as `data-react-id`, that React uses internally. This is useful if you want to use React as a simple static page generator, as stripping away the extra attributes can save lots of bytes.

**`React::Component::Base`**

Reactrb Components are ruby classes that either subclass `React::Component::Base`, or mixin `React::Component`.  Both mechanisms have the same effect.

Instances of React Components are created internally by React when rendering. The instances exist through subsequent renders, and although coupled to React, act like normal ruby instances. The only way to get a valid reference to a React Component instance outside of React is by storing the return value of `React.render`.  Inside other Components, you may use refs to achieve the same result.
