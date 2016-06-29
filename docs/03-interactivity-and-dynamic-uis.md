---
id: interactivity-and-dynamic-uis
title: Interactivity and Dynamic UIs
permalink: interactivity-and-dynamic-uis.html
prev: jsx-gotchas.html
next: multiple-components.html
---

You've already [learned how to display data](/docs/displaying-data.html) with React. Now let's look at how to make our UIs interactive.

## A Simple Example

```javascript
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

## Event Handling and Synthetic Events

With React you attach event handlers to elements using the `on` method. React ensures that all events behave identically in IE8 and above by implementing a synthetic event system. That is, React knows how to bubble and capture events according to the spec, and the events passed to your event handler are guaranteed to be consistent with [the W3C spec](http://www.w3.org/TR/DOM-Level-3-Events/), regardless of which browser you're using.

## Under the Hood: Event Delegation

React doesn't actually attach event handlers to the nodes themselves. When React starts up, it starts listening for all events at the top level using a single event listener. When a component is mounted or unmounted, the event handlers are simply added or removed from an internal mapping. When an event occurs, React knows how to dispatch it using this mapping. When there are no event handlers left in the mapping, React's event handlers are simple no-ops. To learn more about why this is fast, see [David Walsh's excellent blog post](http://davidwalsh.name/event-delegate).

## Components are Just State Machines

React thinks of UIs as simple state machines. By thinking of a UI as being in various states and rendering those states, it's easy to keep your UI consistent.

In React, you simply update a component's state, and then the new UI will be rendered on this new state. React takes care of updating the DOM for you in the most efficient way.

## How State Works

Whenever a state variable changes you invoke the corresponding state variable name followed by a "!" method.  For example `state.liked! !state.like` *gets* the current value of like, toggles it, and then *updates* it.  This in turn causes the component to be
rerendered.   For more details on how this works, and the full syntax of the update method see [the component API reference]( docs/component-api.html#the-state-instance-method)

## What Components Should Have State?

Most of your components should simply take some params and render based on their value. However, sometimes you need to respond to user input, a server request or the passage of time. For this you use state.

**Try to keep as many of your components as possible stateless.** By doing this you'll isolate the state to its most logical place and minimize redundancy, making it easier to reason about your application.

A common pattern is to create several stateless components that just render data, and have a stateful component above them in the hierarchy that passes its state to its children via `params`. The stateful component encapsulates all of the interaction logic, while the stateless components take care of rendering data in a declarative way.

## What *Should* Go in State?

**State should contain data that a component's event handlers, timers, or http requests may change and trigger a UI update.**
When building a stateful component, think about the minimal possible representation of its state, and only store those properties in `state`.  Add to your class methods to compute higher level values from your state variables.  Avoid adding redundant or computed values as state variables as
these values must then be kept in sync whenever state changes.

## What *Shouldn't* Go in State?

`state` should only contain the minimal amount of data needed to represent your UI's state. As such, it should not contain:

* **Computed data:** Don't worry about precomputing values based on state — it's easier to ensure that your UI is consistent if you do all computation during rendering.  For example, if you have an array of list items in state and you want to render the count as a string, simply render `"#{state.list_items.length} list items'` in your `render` method rather than storing the count as another state.
* **Data that does not effect rendering:** For example handles on timers, that need to be cleaned up when a component unmounts should go
in plain old instance variables.
