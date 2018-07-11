---
title: Getting Started with Reactrb and Rails
date: 2016-01-26 16:29 UTC
---

[React.js](//facebook.github.io/react/) support for rails is provided
[react-rails](https://github.com/reactjs/react-rails) gem.

From its project page, React-rails can:

-   Provide various react builds to your asset bundle
-   Transform .jsx in the asset pipeline
-   Render components into views and mount them via view helper & react\_ujs
-   Render components server-side with prerender: true
-   Generate components with a Rails generator
-   Be extended with custom renderers, transformers and view helpers

While `react-rails` provides easy integration with Rails, a Rails
developer cannot leverage the full benefits of React.js, particularly
isomorphic/[universal](https://medium.com/@mjackson/universal-javascript-4761051b7ae9#.rxrgqe5wb)
domain logic code and views since different languages are used on
server and client
sides. [React.rb/reactive-ruby](https://github.com/zetachang/react.rb)
(**react.rb** from here on) builds on top of `react-rails` by allowing
one to write React components in Ruby, courtesy of
[Opal](http://opalrb.com).  Now the Rails programmer can also enjoy
universal domain logic and views written in Ruby via react.js.

The focus of this article will be limited to just getting `react.rb`
up and running on Rails from scratch.

# Generate a rails project that uses Opal

The easiest way to create a Rails project that uses [Opal](http://opalrb.com) is to use the
`--javascript=opal` option. Manual instructions on how add Opal
support to an existing Rails project are given on the [opal-rails](https://github.com/opal/opal-rails)
site. Create a new Rails project with the following command:

    % rails new getting-started-react-rails --javascript=opal

# Add react.rb gems to Gemfile

To use `react.rb`, you need to add 3 gems to your Gemfile:
reactive-ruby<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup>, react-rails and therubyracer

```ruby
    gem 'reactive-ruby', '0.7.29' # nail down compatible version w/ pre 0.14 react-rails
    gem 'react-rails', '1.3.2' # react.rb not compatible ith 1.4.* yet so use this one
    gem 'opal-rails' # already added w/the --javascript=opal option
    gem 'therubyracer', platforms: :ruby # Required for server side prerendering
```

Run `bundle install` after these have been added to your Gemfile.

### Update

Since this article was written there has been Rails generator code
that has been written as a
[standalone gem](https://rubygems.org/gems/reactrb-rails-generator)
that is pending integration with react.rb gem.  Some of conventions
described in this article, which currently match that of existing
documentation and sample Rails project in react.rb will likely be
changing as part of that.

# Convert application.js to application.js.rb

When using opal-rails, it is recommented<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup>
to convert the application.js file to application.js.rb.  Make yours look
like this:

```ruby
    # app/assets/javascripts/application.js.rb
    require 'opal'
    require 'opal_ujs'
    require 'turbolinks'
    require 'react'
    require 'react_ujs'
    require 'components' # to include isomorphic react components on the client
    require_tree '.'
```

# Setup for isomorphic<sup><a id="fnr.3" class="footref" href="#fn.3">3</a></sup> React components

A big perk of react.js is isomorphic code (same code on server and
client side), which leads to A united UI layer. As mentioned before
[react-rails](https://github.com/reactjs/react-rails) provides server rendered react.js components, as well as
other perks as detailed in this [this article](http://bensmithett.com/server-rendered-react-components-in-rails/).  This quote from the
aforementioned article gives one a sense of how big a perk this is.

> The Holy Grail. The united UI layer. Serve up real HTML on first page load, then kick off a client side JS app. All without duplicating a single line of UI code.

Those who have struggled with duplicated views on front and back ends,
in different languages should appreciate that sentiment. To support
isomorphic react.rb components you need to setup a structure for these
**shared** components. The current convention is to make a
`app/views/components` directory containing the components and a
`components.rb` manifest file that will require all the `react.rb`
components, like so:

```ruby
    # app/views/components.rb
    require 'opal'
    require 'reactive-ruby'
    require_tree './components'
```

You may have noticed that, that the `application.js.rb` we created
`require`s this components.rb file to compile these universal
`react.rb` components.

# Make a controller to demonstrate react components

We will be demonstrating several types of components as
examples. Let's make a dedicated controller to demo these components with
dedicated actions for each case.

```sh
    % rails g controller home isomorphic iso_convention search_path client_only
```

# Create your first React Component

So now that we're setup for isomorphic components, lets make our first
react.rb component.  We'll start with a simple "Hello World"
component.  This component takes a single, required param message of
type `String`. Note, param in `react.rb` corresonds to prop in
react.js; `react.rb` calls props "params" to provide a more Rails
familiar API. The component renders this message param in an **h1** element,
and renders a button that, when clicked, calls `alert()` with the same
message.

Put the following into this file **app/views/components/hello.rb**:

```ruby
    class Hello
      include React::Component
      required_param :what, type: String

      def message
        "Hello #{what}"
      end

      def render
        div {
          h1 { message }
          button {"Press me"}.on(:click) {alert message}
        }
      end
    end
```

You can render the `Hello` component directly without needing a
template file in your controller with
`render_component()`. `render_component()` takes an optional (more on
this later) class name of the component and any parameters you wish to
pass the component.  Implement the `isomorphic` action in the
`HomeController` like so

```ruby
    class HomeController < ApplicationController
      def isomorphic
        render_component 'Hello', message: 'World'
      end
    end
```

Start the server, then visit [<http://localhost:3000/home/isomorphic>](http://localhost:3000/home/isomorphic) to
view the component.  By default, react.rb prerenders the component on
the server (the reverse of react-rails' `react_component()`, but you can force Rails to NOT prerender by appending
?no\_prerender=1 to the url, like so

    http://localhost:3000/home/isomorphic?no_prerender=1

Let's take a quick look at the HTML returned by the server in both cases (formatted to be more human-readable)

For [<http://localhost:3000/home/isomorphic>](http://localhost:3000/home/isomorphic)
we see the **h1** and button rendered from the server:

```html
    <div data-react-class="React.TopLevelRailsComponent"
         data-react-props="{&quot;render_params&quot;:{&quot;message&quot;:&quot;World&quot;},&quot;component_name&quot;:&quot;Hello&quot;,&quot;controller&quot;:&quot;Home&quot;}">
      <div data-reactid=".3hx9dqn6rk"
           data-react-checksum="487927662">
        <h1 data-reactid=".3hx9dqn6rk.0">Hello World</h1>
        <button data-reactid=".3hx9dqn6rk.1">Press me</button>
      </div>
    </div>
```
For [<http://localhost:3000/home/isomorphic?no_prerender=1>](http://localhost:3000/home/isomorphic?no_prerender=1)
there is no prerendering and the rendering is done by the client

```html
    <div data-react-class="React.TopLevelRailsComponent"
         data-react-props="{&quot;render_params&quot;:{&quot;message&quot;:&quot;World&quot;},&quot;component_name&quot;:&quot;Hello&quot;,&quot;controller&quot;:&quot;Home&quot;}">
    </div>
```
# Rails conventions, isomorphic (i.e. universal) components and the "default" component

In the Rails tradition of convention over configuration, you can
structure/name your components to match your controllers to support a
"default" component, i.e. a component you do NOT need to specify, for
a controller action. To make a default component for the
`HomeController#iso_convention` action, create the following file:

```ruby
    # app/views/components/home/iso_convention.rb
      module Components
        module Home
          class IsoConvention
            include React::Component

            def render
              h1 { "the message is: #{params[:message]}" }
            end
          end
        end
      end
```

We now call `render_component()` in the action, passing only the
desired params in the action.  `render_component()` will instantiate
the **default** component.

```ruby
    class HomeController < ApplicationController
      def iso_convention
        render_component message: 'World'
      end
    end
```

Browsing [<http://localhost:3000/home/iso_convention>](http://localhost:3000/home/iso_convention)
will render the `Components::Home::IsoConvention` component

# The component search path

For consistency, you should stick with the Rails directory and
filename conventions. There is some flexibility in where you can
place components. The search path for isomorphic components in
react.rb is described here: [here](https://github.com/zetachang/react.rb#changing-the-top-level-component-name-and-search-path) which writes:

> Changing the top level component name and search path
>
> You can control the top level component name and search path.
>
> You can specify the component name explicitly in the
> render\_component method. render\_component "Blatz will search the
> for a component class named Blatz regardless of the controller
> method.
>
> Searching for components normally works like this: Given a
> controller named "Foo" then the component should be either in the
> Components::Foo module, the Components module (no controller -
> useful if you have just a couple of shared components) or just the
> outer scope (i.e. Module) which is useful for small apps.
>
> Saying render\_component "::Blatz" will only search the outer scope,
> while "::Foo::Blatz" will look only in the module Foo for a class
> named Blatz.

# Exploring the component search path

Let's play around with several components that have the same class name and
see how the search path resolves which component to use.  Create the
file below:

`app/views/components/search_path.rb`

```ruby
      # This class departs from 1 class/file and diretory
      # structure/convention, using this to test search path

    class SearchPath
      include React::Component
      def render
        h1 {"::SearchPath"}
      end
    end

    module Home
      class SearchPath
        include React::Component
        def render
          h1 {"Home::SearchPath"}
        end
      end
    end

    module Components
      class SearchPath
        include React::Component
        def render
          h2 { 'Components::SearchPath' }
        end
      end
    end

    module Components
      module Home
        class SearchPath
          include React::Component
          def render
            h2 { 'Components::Home::SearchPath' }
          end
        end
      end
    end
```

To render the "default" component, we can just call `render_component()`:

```ruby
    class HomeController < ApplicationController
      def search_path
        render_component
      end
    end
```

Hitting [<http://localhost:3000/home/search_path>](http://localhost:3000/home/search_path) the component rendered
`Home::SearchPath` as evidenced by the text in the H1 element.

Specifying the component by unqualified class name in `render_component()`, yields the same result: `Home::SearchPath=`

```ruby
    class HomeController < ApplicationController
      def search_path
        render_component "SearchPath"
      end
    end
```

We can explore what will be found next the search path by changing the
found component's name to `SearchPath1`, and then refreshing
<http://localhost:3000/home/search_path> to see which component is
found.  Doing this for each found component gets the following
results:

<table style='border:2px black; borderspacing: 4px; ' cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr style='border:2px solid black; padding: 4px; '>
<th style='border:2px solid black; padding: 4px; 'scope="col" class="org-left">Class name changed from SearchPath</th>
<th style='border:2px solid black; padding: 4px; 'scope="col" class="org-left">Component Rendered by search path</th>
</tr>
</thead>

<tbody>
<tr style='border:2px solid black; padding: 4px; '>
<td style='border:2px solid black; padding: 4px; 'class="org-left">none</td>
<td style='border:2px solid black; padding: 4px; 'class="org-left">Home::SearchPath</td>
</tr>


<tr style='border:2px solid black; padding: 4px; '>
<td style='border:2px solid black; padding: 4px; 'class="org-left">Home::SearchPath</td>
<td style='border:2px solid black; padding: 4px; 'class="org-left">Components::Home::SearchPath</td>
</tr>


<tr style='border:2px solid black; padding: 4px; '>
<td style='border:2px solid black; padding: 4px; 'class="org-left">Components::Home::SearchPath</td>
<td style='border:2px solid black; padding: 4px; 'class="org-left">::SearchPath</td>
</tr>


<tr style='border:2px solid black; padding: 4px; '>
<td style='border:2px solid black; padding: 4px; 'class="org-left">::SearchPath</td>
<td style='border:2px solid black; padding: 4px; 'class="org-left">Components::SearchPath</td>
</tr>
</tbody>
</table>

If we rename all the `SearchPath1` classes back to `SearchPath`, we
can force the search path to find our desired component by specifying
the full namespace in the `render_component()` call

```ruby
    class HomeController < ApplicationController
      def search_path
        render_component "SearchPath"
        # render_component "Components::SearchPath"
        # render_component "Components::Home::SearchPath"
        # render_component "Home::SearchPath"
        # render_component "::SearchPath"
      end
    end
```

# Directory conventions for react-rails, Opal and react.rb

The **react-rails** Javascript component generators create react.js
components in the `app/assets/javascripts/components` directory.  This
makes sense, esp. since Rails out of the box does NOT support
isomorphic code and views; hence this directoy is a logical and
"Rails-like" place for Javascript to go.  Similarly, if you are just
using opal-rails and not not react.rb, then by convention, your `Opal`
code will be placed under `app/assets/javascripts` where the asset
pipeline knows how to find and transpile the `Opal` files to Javascript.
React.rb challenges these directory conventions.  As react.js is often
called the **V** of **MVC**, then it makes sense for react.rb components
to live under the `app/views/components` directory, esp. as they can
also be rendered on the server.  React.rb is young, and conventions
may change, but at the momemnt this is the prescribed convention.

You can create react.rb components more in line with react-rails and
Opal conventions by placing them somewhere under the
`app/assets/javascripts` directory. The Opal files will be found by
Rails anywhere that the asset pipeline is configured to find
javascript files for both server and client rendering, but I would
recommend a structure similar to how react-rails, i.e. in
`app/assets/javascripts/components` to make them easy to find.

Let's put the "client side only" component into
`app/assets/javascripts`. Since Opal will find the file anywhere the
asset pipeline knows to look, this would be more for organizational
conventions rather than a configuration necessary to make it work.

```ruby
    # app/assets/javascripts/components/client_only.rb
    class ClientOnly
      include React::Component
      required_param :message, type: String

      def render
        h1 { "Client only: #{params[:message]}" }
      end
    end
```

Then in the template for the `client_only` action , you can render the
component client side via the `react_component()` view helper provided
by react-rails. Since react.rb wraps calls to react.js, the components
become react.js components.

```html
    <h1>Home#client_only</h1>
    <p>Find me in app/views/home/client_only.html.erb</p>
    <%= react_component 'ClientOnly', message: 'World' %>
```

# That's all for now.

So now you have a Rails project with react.rb running with several
examples of react.rb components. All of this code exists in a rails
project
[here.](https://github.com/fkchang/getting-started-react-rails) This
should be enough to get one started.  Enjoy react.rb and Rails!

<h2 class="footnotes">Footnotes: </h2>

<div class="footdef"><sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> <div class="footpara">reactive-ruby will fold back into react.rb with the 0.9.0 versions (currently at 0.7.36).  Plans are discussed in the react.rb [roadmap](https://github.com/zetachang/react.rb#road-map)</div></div>

<div class="footdef"><sup><a id="fn.2" class="footnum" href="#fnr.2">2</a></sup>
    <div class="footpara">A change was made starting with Opal 0.8.\*, to support ordered
requires. If one wishes to continue to use application.js instead
application.rb, one needs to manually load each opal file in the
application.js, as below.  Use of application.rb will automatically load the files in question
</div></div>

```javascript
// application.js
//= require opal
//= require greeter
//= require_self
Opal.load('greeter'); // you have to load the opal file
// etc.
```


<div class="footdef"><sup><a id="fn.3" class="footnum" href="#fnr.3">3</a></sup> <div class="footpara">While the pattern is that universal will be taking the place of isomorphic, I will use the term isomorphic here because the react.rb docs refer to it as isomorphic</div></div>
