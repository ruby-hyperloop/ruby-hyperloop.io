## Working with React components

[The source code to this tutorial is here](https://github.com/barriehadfield/reactrb-showcase)

It is time to reap some of the rewards from all the hard work above. We have everything setup so we can easily add front end components and work with them in Reactrb. Lets jump in and add a native React component that plays a video.

[We are going to use Pete Cook's React rplayr](https://github.com/CookPete/rplayr)

First let's install the component via NPM:
```text
npm install react-player --save
```

Next we need to `require` it in `webpack/client_and_server.js`
```javascript
ReactPlayer = require('react-player')
```

Next run webpack so it can be bundled
```text
webpack
```

And then finally let's add it to our Show component:
```ruby
def render
  div do
    ReactPlayer(url:  'https://www.youtube.com/embed/FzCsDVfPQqk',
      playing: true
    )
  end
end
```

Refresh your browser and you should have a video. How simple was that!

## Working with React Bootstrap

[We will be using React Bootstrap which is a native React library](https://react-bootstrap.github.io/)

The main purpose for React Bootstrap is that it abstracts away verbose HTML & CSS code into React components which makes it a lot cleaner for React JSX developers. One of the very lovely things about Reactrb is that we already work in beautiful Ruby. To emphasise this point, consider the following:

Sample 1 - In HTML (without React Bootstrap):

	<button id="something-btn" type="button" class="btn btn-success btn-sm">
	  Something
	</button>
	$('#something-btn').click(someCallback);

Sample 2 - In JSX (with React Bootstrap components):

	<Button bsStyle="success" bsSize="small" onClick={someCallback}>
	  Something
	</Button>

Sample 3 - In Reactrb (without React Bootstrap):

	button.btn_success.btn_sm {'Something'}.on(:click) do
		someMethod
	end

Sample 4 - In Reactrb (with React Bootstrap):

	Bs.Button(bsStyle: 'success' bsSize: "small") {'Something'}.on(:click) do
		someMethod
	end

As you can see, sample 3 & 4 are not that different and as a Reactrb developer, I actually prefer sample 3. If I were a JavaScript or JSX developer I would completely understand the advantage of abstracting Bootstrap CSS into React Components so I don't have to work directly with CSS and JavaScript but this is not the case with Reactrb as CSS classes are added to HTML elements with simple dot notation:

	span.pull_right {}

compiles to (note the conversion from _ to -)

	<span class='pull-right'></span>

So I hear you ask: why if I prefer the non-React Bootstrap syntax why am worrying about React Bootstrap? For one very simple reason: components like Navbar and Modal that requires `bootstrap.js` will not work with React on it's own so without the React Bootstrap project you would need to implement all that functionality yourself. The React Bootstrap project has re-implemented all this functionality as React components.

Lets implement a Navbar in this project using React Bootstrap in Reactrb. First, we need to install Bootstrap and React Bootstrap:

	npm install bootstrap react-bootstrap --save

Note: The `--save` option will update the package.json file.

And then we need to `require` it in `webpack/client_and_server.js` by adding this line:
```javascript
ReactBootstrap = require('react-bootstrap')
```
Run the `webpack` command again, and restart your rails server.

If you refresh your browser now and open the JavaScript console we will be able to interact with React Bootstrap by typing:

In the JavaScript console type: ```ReactBootstrap```

and you will see the ReactBootstrap object with all its components like Accordion, Alert, Badge, Breadcrumb, etc. This is great news, React Bootstrap is installed and ready to use. Accessing the JavaScript object in this way is a really great way to see what you have to work with. Sometimes the documentation of a component is not as accurate as actually seeing what you have in the component itself.

To make sure everything is working lets add a *Button* to our our Show component like this:

```ruby
module Components
  module Home
    class Show < React::Component::Base
      def render
        ReactBootstrap::Button(bsStyle: 'success', bsSize: "small") do
          'Success'
        end.on(:click) do
          alert('you clicked me!')
        end
      end
    end
  end
end
```
Notice that we reference `ReactBoostrap` in ruby using the same identifer that was in the require statement in our `client_and_server.js` webpack bundle.  The first time Reactrb hits the `ReactBootstrap` constant it will not be defined. This triggers a search of the javascript name space for something that looks either like a component or library of components.  It then defines the appropriate module or component class wrapper in ruby.

Visit your page and if all is well you will see a clickable button.  However it will not have any styles.  This is because ReactBootstrap does not automatically depend on any particular style sheet, so we will have to supply one.  An easy way to do this is to just copy the css file from the bootstrap repo, and stuff it our rails assets directory, however with a little upfront work we can setup webpack to do it all for us.

First lets add four webpack *loaders* using npm:
```text
npm install css-loader file-loader style-loader url-loader --save-dev
```
Notice we use `--save-dev` instead of just `--save` as these packages are only used in the development process.

Now edit your `webpack.config.js` file, and update the loaders section so it looks like this:

```javascript
var path = require("path");

module.exports = {
...
    module: {
      loaders: [
        { test: /\.css$/,
          loader: "style-loader!css-loader"
        },
        { test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
          loader: 'url?limit=10000&mimetype=application/font-woff'
        },
        { test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
          loader: 'url?limit=10000&mimetype=application/octet-stream'
        },
        { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
          loader: 'file'
        },
        { test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
          loader: 'url?limit=10000&mimetype=image/svg+xml'
        }
      ]
    },
...
};
```

We have set webpack up so that when a css file is required it uses the style loader to process the file.  Because the bootstrap css file will require font face files, we also have 4 font loaders.  All this will package up everything when we require any css file.

Now we are ready to require CSS files, and have webpack build a complete bundle including the css and any fonts referenced.

To bundle in the bootstrap css file add this line to `webpack/client_only.js`
```javascript
require('bootstrap/dist/css/bootstrap.css');
```

And install the bootstrap package
```text
npm install bootstrap --save
```

Now run `webpack` to update our bundles, and restart your server.  Now our button is properly styled you should be rewarded with a nice Bootstrap styled green Success Button.

Now that everything is loaded, lets update our component to use a few more of the Bootstrap components.  Update your Show component so that it looks like this:

```ruby
module Components
  module Home
    class Show < React::Component::Base

      def say_hello(i)
        alert "Hello from number #{i}"
      end

      def render
        div do
          ReactBootstrap::Navbar(bsStyle: :inverse) do
            ReactBootstrap::Nav() do
              ReactBootstrap::NavbarBrand() do
                a(href: '#') { 'Reactrb Showcase' }
              end
              ReactBootstrap::NavDropdown(
                eventKey: 1,
                title: 'Things',
                id: :drop_down
              ) do
                (1..5).each do |n|
                  ReactBootstrap::MenuItem(href: '#',
                    key: n,
                    eventKey: "1.#{n}"
                  ) do
                    "Number #{n}"
                  end.on(:click) { say_hello(n) }
                end
              end
            end
          end
          div.container do
            ReactPlayer(url: 'https://www.youtube.com/embed/FzCsDVfPQqk',
              playing: true
            )
          end
        end
      end
    end
  end
end
```

A few things to notice in the code above:

We add React Bootstrap components simply by `ReactBootstrap::Name` where `Name` is the JavaScriot component you want to render. All the components are documented in the React Bootstrap [documentation](https://react-bootstrap.github.io/components.html)

See with `div.container` we are mixing in CSS style which will compile into `<div class='container'>`

Also notice how I have added an `.on(:click)` event handler to the `MenuItem` component while setting `href: '#'` as this will allow us to handle the event instead of navigating to a new page.

So far we have a very basic application which is looking OK and showing a video. Time to do something a little more interesting. How about if we add Post and Comment functionality which will let us explore Reactive Record!
