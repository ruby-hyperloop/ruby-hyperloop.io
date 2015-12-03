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

You almost never need to directly call create_element, the DSL, Rails, and jQuery interfaces take of this for you.


### React.clone_element

Currently you need to directly access this as like this:

```ruby
`React.cloneElement(#{ele.to_n}, #{props.to_n})`
```

See the React.js documentation on details


### React.isValidElement

```ruby
is_valid_element?(ele)
```

Verifies the object is a valid react element.


### React.DOM

`React.DOM` provides convenience wrappers around `React.createElement` for DOM components. These should only be used when not using JSX. For example, `React.DOM.div(null, 'Hello World!')`


### React.PropTypes

Macro???


### React.Children

Move to Component API (i.e. self.children)

#### React.Children.map

```javascript
array React.Children.map(object children, function fn [, object thisArg])
```

Invoke `fn` on every immediate child contained within `children` with `this` set to `thisArg`. If `children` is a nested object or array it will be traversed: `fn` will never be passed the container objects. If children is `null` or `undefined` returns `null` or `undefined` rather than an array.

#### React.Children.forEach

```javascript
React.Children.forEach(object children, function fn [, object thisArg])
```

Like `React.Children.map()` but does not return an array.

#### React.Children.count

```javascript
number React.Children.count(object children)
```

Return the total number of components in `children`, equal to the number of times that a callback passed to `map` or `forEach` would be invoked.

#### React.Children.only

```javascript
object React.Children.only(object children)
```

Return the only child in `children`. Throws otherwise.

#### React.Children.toArray

```javascript
array React.Children.toArray(object children)
```

Return the `children` opaque data structure as a flat array with keys assigned to each child. Useful if you want to manipulate collections of children in your render methods, especially if you want to reorder or slice `this.props.children` before passing it down.

## ReactDOM

The `react-dom` package provides DOM-specific methods that can be used at the top level of your app and as an escape hatch to get outside of the React model if you need to. Most of your components should not need to use this module.

### ReactDOM.render

```javascript
ReactComponent render(
  ReactElement element,
  DOMElement container,
  [function callback]
)
```

Render a ReactElement into the DOM in the supplied `container` and return a [reference](/docs/more-about-refs.html) to the component (or returns `null` for [stateless components](/docs/reusable-components.html#stateless-functions)).

If the ReactElement was previously rendered into `container`, this will perform an update on it and only mutate the DOM as necessary to reflect the latest React component.

If the optional callback is provided, it will be executed after the component is rendered or updated.

> Note:
>
> `ReactDOM.render()` controls the contents of the container node you pass in. Any existing DOM elements
> inside are replaced when first called. Later calls use React’s DOM diffing algorithm for efficient
> updates.
>
> `ReactDOM.render()` does not modify the container node (only modifies the children of the container). In
> the future, it may be possible to insert a component to an existing DOM node without overwriting
> the existing children.


### ReactDOM.unmountComponentAtNode

```javascript
boolean unmountComponentAtNode(DOMElement container)
```

Remove a mounted React component from the DOM and clean up its event handlers and state. If no component was mounted in the container, calling this function does nothing. Returns `true` if a component was unmounted and `false` if there was no component to unmount.


### ReactDOM.findDOMNode

```javascript
DOMElement findDOMNode(ReactComponent component)
```
If this component has been mounted into the DOM, this returns the corresponding native browser DOM element. This method is useful for reading values out of the DOM, such as form field values and performing DOM measurements. **In most cases, you can attach a ref to the DOM node and avoid using `findDOMNode` at all.** When `render` returns `null` or `false`, `findDOMNode` returns `null`.

> Note:
>
> `findDOMNode()` is an escape hatch used to access the underlying DOM node. In most cases, use of this escape hatch is discouraged because it pierces the component abstraction.
>
> `findDOMNode()` only works on mounted components (that is, components that have been placed in the DOM). If you try to call this on a component that has not been mounted yet (like calling `findDOMNode()` in `render()` on a component that has yet to be created) an exception will be thrown.
>
> `findDOMNode()` cannot be used on stateless components.

## ReactDOMServer

The `react-dom/server` package allows you to render your components on the server.

### ReactDOMServer.renderToString

```javascript
string renderToString(ReactElement element)
```

Render a ReactElement to its initial HTML. This should only be used on the server. React will return an HTML string. You can use this method to generate HTML on the server and send the markup down on the initial request for faster page loads and to allow search engines to crawl your pages for SEO purposes.

If you call `ReactDOM.render()` on a node that already has this server-rendered markup, React will preserve it and only attach event handlers, allowing you to have a very performant first-load experience.


### ReactDOMServer.renderToStaticMarkup

```javascript
string renderToStaticMarkup(ReactElement element)
```

Similar to `renderToString`, except this doesn't create extra DOM attributes such as `data-react-id`, that React uses internally. This is useful if you want to use React as a simple static page generator, as stripping away the extra attributes can save lots of bytes.
