---
id: top-level-api
title: Top-Level API
permalink: top-level-api.html
next: component-api.html
redirect_from: "/docs/reference.html"
---

## React

The `React` module name spaces all the React classes and modules.  

See the [Getting Started](/docs/getting-started.html) section for details on getting react loaded in your environment.

### React::Component and React::Component::Base

React components classes either include React::Component or are subclasses of React::Component::Base.  

```ruby
class Component < React::Component::Base
end
# or
class AnotherComponent
  include React::Component
end
```

At a minimum every component class must define a `render` method which returns **one single** child element. That child may have an arbitrarily deep child structure. 

```ruby
class Component < React::Component::Base
  def render
    div
  end
end
```

To render a component, you reference its class name in the DSL as a method call.  This creates a new instance, passes any parameters proceeds with the component lifecycle.  

```
class AnotherComponent < React::Component::Base
  def render
    Component() # ruby syntax requires either () or {} following the class name
  end
end
```

Note that you should never redefine the new or initialize methods, or call them directly.  The equivilent of `initialize` is the `before_mount` callback.  For more information see [Component Specs and Lifecycle](/docs/component-specs.html). 


### React.create_element

React.create_element "instantiates" a component (called an element.)  It takes either the component class, or a string (representing a built in tag
such as div, or span), the parameters (properties) to be passed to the element, and optionally a block that will be evaluated to 
build the enclosed children elements

```ruby
React.create_element("div", prop1: "foo", prop2: 12) { para { "hello" }; para { "goodby" } )
# generates <div prop1="foo" prop2="12"><p>hello</p><p>goodby</p></div>
```

You almost never need to directly call create_element, the DSL, Rails, and jQuery interfaces take care of this for you.

```ruby
# dsl - creates element and pushes it into the rendering buffer
    MyComponent(...params...) { ...optional children... }
# dsl - component will NOT be placed in the rendering buffer
    MyComponent(...params...) { ... }.as_node
# rails controller - renders component as the view
    render_component("MyComponent", ...params...) 
# rails view helper - renders component into the view (like a partial)
    react_component("MyComponent", ...)
# jQuery (Note Element is the Opal jQuery wrapper, not be confused with React::Element
    Element['#container'].render { MyComponent(...params...) { ...optional children... } }  
```


### React.is_valid_element?

```ruby
is_valid_element?(object)
```

Verifies `object` is a valid react element.  Note that `React::Element` wraps the React.js native class, 
`React.is_valid_element?` returns true for both classes unlike `object.is_a? React::Element`

### React.render

```ruby
React.render(element, container) { puts "element rendered" }
```

Render an `element` into the DOM in the supplied `container` and return a [reference](/docs/more-about-refs.html) to the component.

If the element was previously rendered into `container`, this will perform an update on it and only mutate the DOM as necessary to reflect the latest React component.

If the optional block is provided, it will be executed after the component is rendered or updated.

> Note:
>
> `React.render()` controls the contents of the container node you pass in. Any existing DOM elements
> inside are replaced when first called. Later calls use React’s DOM diffing algorithm for efficient
> updates.
>
> `React.render()` does not modify the container node (only modifies the children of the container). In
> the future, it may be possible to insert a component to an existing DOM node without overwriting
> the existing children.


### React.unmount_component_at_node

```ruby
React.unmount_component_at_node(container)
```

Remove a mounted React component from the DOM and clean up its event handlers and state. If no component was mounted in the container, calling this function does nothing. Returns `true` if a component was unmounted and `false` if there was no component to unmount.

### React.render_to_string

```ruby
React.render_to_string(element)
```

Render an element to its initial HTML. This is typically only be used on the server. React will return a string containing the HTML. You can use this method to generate HTML on the server and send the markup down on the initial request for faster page loads and to allow search engines to crawl your pages for SEO purposes.

If you call `React.render` on a node that already has this server-rendered markup, React will preserve it and only attach event handlers, allowing you to have a very performant first-load experience.


### React.render_to_static_markup

```ruby
React.render_to_static_markup(element)
```

Similar to `render_to_string`, except this doesn't create extra DOM attributes such as `data-react-id`, that React uses internally. This is useful if you want to use React as a simple static page generator, as stripping away the extra attributes can save lots of bytes.
