---
title: Docs
---
## Using Javascript Components

While it is quite possible to develop large applications purely in Reactrb with a ruby back end like rails, you may eventually find you want to use some pre-existing React Javascript library.   Or you may be working with an existing React-JS application, and want to just start adding some Reactrb components.

Either way you are going to need to import Javascript components into the Reactrb namespace.  Reactrb provides both manual and automatic mechanisms to do this depending on the level of control you need.

- [Importing Components](#importing-components)
- [Importing Libraries](#importing-libraries)
- [Auto Importing](#auto-import)
- [Including React Source](#including-react-source)
- [Using Webpack](#using-webpack)

## Importing Components

Lets say you have an existing React Component written in javascript that you would like to access from Reactrb.  

Here is a simple hello world component:

```javascript
window.SayHello = React.createClass({
  displayName: "SayHello",
  render: function render() {
    return React.createElement("div", null, "Hello ", this.props.name);
  }
})
```

Assuming that this component is loaded some place in your assets, you can then access this from Reactrb by creating a wrapper component:

```ruby
class SayHello < React::Component::Base
  imports 'SayHello'
end

class MyBigApp < React::Component::Base
  def render
    # SayHello will now act like any other Reactrb component
    SayHello name: 'Matz'
  end
end
```

The `imports` directive takes a string (or a symbol) and will simply evaluate it and check to make sure that the value looks like a React component, and then set the underlying native component to point to the imported component.


## Importing Libraries

Many React components come in libraries.  The `ReactBootstrap` library is one example.  You can import the whole library at once using the `React::NativeLibrary` class.  Assuming that you have initialized `ReactBootstrap` elsewhere, this is how you would bring it into Reactrb.

```ruby
class RBS < React::NativeLibrary
  imports 'ReactBootstrap'
end
```

We can now access our bootstrap components as components defined within the RBS scope:

```ruby
  # taken  from Barrie Hadfield's excellent guide: http://tutorials.pluralsight.com/ruby-ruby-on-rails/reactrb-showcase
module Components
  module Home
    class Show < React::Component::Base

      def say_hello(i)
        alert "Hello from number #{i}"
      end

      render RBS::Navbar, bsStyle: :inverse do
        RBS::Nav() do
          RBS::NavbarBrand() do
            a(href: '#') { 'Reactrb Showcase' }
          end
          RBS::NavDropdown(eventKey: 1, title: 'Things', id: :drop_down) do
            (1..5).each do |n|
              RBS::MenuItem(href: '#', key: n, eventKey: "1.#{n}") do
                "Number #{n}"
              end.on(:click) { say_hello(n) }
            end
          end
        end
      end
    end
  end
end
```

Besides the `imports` directive, `React::NativeLibrary` also provides a rename directive that takes pairs in the form `oldname => newname`.  For example:

```ruby
  rename 'NavDropdown' => 'NavDD', 'Navbar' => 'NavBar', 'NavbarBrand' => 'NavBarBrand'
```

`React::NativeLibrary` will import components that may be deeply nested in the library.  For example consider a component was defined as `MyLibrary.MySubLibrary.MyComponent`:

```ruby
class MyLib < React::NativeLibrary
  imports 'MyLibrary'
end

class App < React::NativeLibrary
  def render  
    ...
    MyLib::MySubLibrary::MyComponent ...
    ...
  end
end
```

Note that the `rename` directive can be used to rename both components and sublibraries, giving you full control over the ruby names of the components and libraries.

## Auto Import

If you use a lot of libraries and are using a Javascript tool chain with Webpack, having to import the libraries in both Reactrb and Webpack is redundant and just hard work.

Instead you can opt-in for *auto importing* Javascript components into Reactrb as you need them.  Simply `require react/auto-import` immediately after you `require reactrb`.  

For example typically you might have this:

```ruby
  # app/views/components.rb
require 'opal'
require 'reactrb'
require 'reactrb/auto-import' # this opts into auto-importing javascript components
if React::IsomorphicHelpers.on_opal_client?
  require 'opal-jquery'
  require 'browser'
  require 'browser/interval'
  require 'browser/delay'
end
require_tree './components'
```

Now you do not have to use component `imports` directive or `React::NativeLibrary` unless you need to rename a component.

In Ruby all module and class names normally begin with an uppercase letter.  However in Javascript this is not always the case, so the auto import will first try the Javascript name that exactly matches the Ruby name, and if that fails it will try the same name with the first character downcased.  For example

`MyComponent` will first try `MyComponent` in the Javascript name space, then `myComponent`.

Likewise MyLib::MyComponent would match any of the following in the Javascript namespace: `MyLib.MyComponent`, `myLib.MyComponent`, `MyLib.myComponent`, `myLib.myComponent`

*How it works:  The first time Ruby hits a native library or component name, the constant value will not be defined.  This will trigger a lookup in the javascript name space for the matching component or library name.  This will generate either a new subclass of React::Component::Base or React::NativeLibrary that imports the javascript object, and no further lookups will be needed.*

## Including React Source  

If you are in the business of importing components with a tool like Webpack, then you will need to let Webpack (or whatever dependency manager you are using) take care of including the React source code.  Just make sure that you are *not* including it on the ruby side of things.  Reactrb is currently tested with React versions 13, 14, and 15, so its not sensitive to the version you use.

However it gets a little tricky if you are using the react-rails gem.  Each version of this gem depends on a specific version of React, and so you will need to manually declare this dependency in your Javascript dependency manager.  Consult this [table](https://github.com/reactjs/react-rails/blob/master/VERSIONS.md) to determine which version of React you need. For example assuming you are using `npm` to install modules and you are using version 1.7.2 of react-rails you would say something like this:

```bash
npm install react@15.0.2 react-dom@15.0.2 --save
```  

## Using Webpack

Just a word on Webpack: If you a Ruby developer who is new to using Javascript libraries then we recommend using Webpack to manage javascript component dependencies.  Webpack is essentially bundler for Javascript.   Barrie Hadfield has put together a very nice [tutorial](http://tutorials.pluralsight.com/ruby-ruby-on-rails/reactrb-showcase) to get you started here.  

There are also good tutorials on integrating Webpack with existing rails apps a google search away.
