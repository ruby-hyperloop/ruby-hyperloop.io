---
id: multiple-components
title: Multiple Components
permalink: multiple-components.html
prev: interactivity-and-dynamic-uis.html
next: reusable-components.html
---

So far, we've looked at how to write a single component to display data and handle user input. Next let's examine one of React's finest features: composability.

## Motivation: Separation of Concerns

By building modular components that reuse other components with well-defined interfaces, you get much of the same benefits that you get by using functions or classes. Specifically you can *separate the different concerns* of your app however you please simply by building new components. By building a custom component library for your application, you are expressing your UI in a way that best fits your domain.

## Composition Example

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

## Ownership

In the above example, instances of `Avatar` *own* instances of `ProfilePic` and `ProfileLink`. In React, **an owner is the component that sets the `params` of other components**. More formally, if a component `X` is created in component `Y`'s `render` method, it is said that `X` is *owned by* `Y`. As discussed earlier, a component cannot mutate its `params` — they are always consistent with what its owner sets them to. This fundamental invariant leads to UIs that are guaranteed to be consistent.

It's important to draw a distinction between the owner-ownee relationship and the parent-child relationship. The owner-ownee relationship is specific to React, while the parent-child relationship is simply the one you know and love from the DOM. In the example above, `Avatar` owns the `div`, `ProfilePic` and `ProfileLink` instances, and `div` is the **parent** (but not owner) of the `ProfilePic` and `ProfileLink` instances.

## Children

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

## Data Flow

In React, data flows from owner to owned component through the params as discussed above. This is effectively one-way data binding: owners bind their owned component's param to some value the owner has computed based on its `params` or `state`. Since this process happens recursively, data changes are automatically reflected everywhere they are used.
