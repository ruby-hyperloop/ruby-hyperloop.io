---
title: Hyperloop Express Gem
---
# Hyperloop Express

Github: [Reactrb Express](https://github.com/reactrb/reactrb-express)

React.rb for static sites, with no build process needed.

## How To

1. Include reactrb-express.js in with your js files, or link to it from here: https://rawgit.com/reactrb/reactrb-express/master/reactrb-express.js
2. Link to a version of jQuery
3. Specify your ruby code inside of `<script type="text/ruby">...</script>` tags    
   or link to your ruby code using the src attribute `<script type="text/ruby" src=.../>`

## What is included

+ Opal (Ruby to Javascript Transpiler) - currently version 0.9
+ Reactrb (Ruby React.js wrapper)
+ React - currently version 15
+ Opal-Jquery (Ruby Jquery wrapper, including HTTP, timers, and of course DOM queries)

## How it works

Your ruby code will be compiled by the browser into javascript, and executed.  Any compilation or runtime errors
will be briefly reported to the console.

Ruby classes can subclass React::Component::Base to become React components, and then use the Reactrb
DSL to dynamically generate reactive DOM nodes.

## Example

See this example in action here: http://reactrb.github.io/reactrb-express/

index.html:
``` html
<!DOCTYPE html>
<!--[if IE]><![endif]-->
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Reactrb-Express Demo</title>
    <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="https://rawgit.com/reactrb/reactrb-express/master/reactrb-express.js"></script>

    <!-- ruby scripts can be fetched from the server or other remote source -->
    <script type="text/ruby" src="clock.rb"></script>

    <!-- or the ruby code can specified directly inline -->
    <script type="text/ruby">
    Element['#clock'].render do
      Clock format: 'The time is: %a, %e %b %Y %H:%M:%S %z'
    end
    </script>

  </head>
  <body>
    <div id="clock"></div>
    <!--

    instead of using Element[...].render to attach a top level component, you
    can specify the react component and parameters using data- tags:

    <div data-reactrb-mount="Clock"
         data-format="The time is: %a, %e %b %Y %H:%M:%S %z">
    </div>

    -->
  </body>
</html>
```

```ruby
# clock.rb:  Displays the current time
class Clock < React::Component::Base
  param format: '%a, %e %b %Y %H:%M'
  before_mount do
    state.time! Time.now.strftime(params.format)
    every(1) { state.time! Time.now.strftime(params.format) }
  end

  def render
    state.time
  end
end
```

# Want a larger example?  

The [Reactrb ChatRoom application and tutorial](http://reactrb.github.io/docs/tutorial.html) uses Reactrb-Express.

# Trying it out using github

Github makes a great sandbox to try out small Reactrb online with nothing but your browser.

Have a look at the instructions here: https://pages.github.com/

but rather than "cloning" the repo, and editing your files on your computer
you can just create and edit files right on the github site.

# Mounting Components

In addition to the standard ways to mount top level components reactrb-express will directly mount components onto DOM elements that have the `data-reactrb-mount` attribute.  The attribute value should be the fully qualified name of the component.  For example "Clock".  Any additional data attributes will be passed as params to the component.  The attribute names will be snake cased (i.e. `data-foo-bar` becomes the `foo_bar` key)

# Building and Contributing

To build, clone the repo, run `bundle install` and then `bundle exec rake`

This will combine all the pieces and build the `reactrb-express.js` file.

To be sure we have no ruby dependencies we use this server for smoke testing:

`python -m SimpleHTTPServer 4000`

Contributions are welcome - things we need:

+ Examples
+ Some test cases
+ Minimization
