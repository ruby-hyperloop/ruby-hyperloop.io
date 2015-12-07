---
id: displaying-data
title: Displaying Data
permalink: displaying-data.html
prev: why-react.html
next: jsx-in-depth.html
---

The most basic thing you can do with a UI is display some data. React makes it easy to display data and automatically keeps the interface up-to-date when the data changes.

## Getting Started

Let's look at a really simple example. Create a `hello-react.html` file with the following code:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Hello React</title>
    <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="https://rawgit.com/reactive-ruby/inline-reactive-ruby/master/inline-reactive-ruby.js"></script>
  </head>
  <body>
    <div id="example"></div>
    <script type="text/ruby">

      // ** Your code goes here! **

    </script>
  </body>
</html>
```

For the rest of the documentation, we'll just focus on the ruby code and assume it's inserted into a template like the one above. Replace the placeholder comment above with the following JSX:

```ruby
class HelloWorld < React::Component::Base
  param :time, type: Time
  def render
    para do
      span { "Hello, " }
      input(type: :text, placeholder: "Your Name Here")
      span { "! It is #{params.time}"}
    end
  end
end

every(1) do
  Element["#example"].render do
    HelloWorld(time: Time.now)
  end
end
```

## Reactive Updates

Open `hello-react.html` in a web browser and type your name into the text field. Notice that React is only changing the time string in the UI — any input you put in the text field remains, even though you haven't written any code to manage this behavior. React figures it out for you and does the right thing.

The way we are able to figure this out is that React does not manipulate the DOM unless it needs to. **It uses a fast, internal mock DOM to perform diffs and computes the most efficient DOM mutation for you.**

The inputs to this component are called `params` (react.js props). They are passed as key-value pairs to a component like a normal ruby method.

## Components are Classes with a `render` method.

React components are very simple. They are classes that have a render method that generates HTML.  When an instance of a component class is initialized it is passed the initial param values and the render method is called.  When new params are provided the params will be updated, and the render method called again.  The underlying React.js system takes care of making this fast and effecient.


> Note:
>
> **One limitation**: React components can only render a single root node. If you want to return multiple nodes they *must* be wrapped in a single root.

## DSL (Domain Specific Language) Syntax

The React philosophy is that components are the right way to separate concerns rather than by "templates" and "display logic."  This is because the resulting markup and the code that generates it are intimately tied together.  Additionally, display logic is often very complex and using template languages to express it becomes cumbersome.

The React approach is to generate HTML and component trees directly right in the component class using Ruby so that you can use all of the expressive power of a real programming language to build UIs.

To enable this every React.rb component class has access to set of class and instance methods that makes specifying the component, and build HTML and event handlers straightforward.  

For example within the render method the `a` method generates an anchor tag like this:

```ruby
a(href: 'https://reactive-ruby.github.io') { 'Get Reactive' }
```

The following sections describe the syntax and features of the React.rb DSL.

> Note: 
>
> Under the hood everything maps to React.js function calls in a straight forward manner.  The React.rb DSL is roughly
> analogous to the React.js JSX, but because its "just ruby" you don't have to learn a new language, and switch mental gears
> while writing code.


