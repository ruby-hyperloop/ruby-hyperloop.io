# Ruby-Hyperloop Static Website

The static site is built with [Middleman](https://middlemanapp.com/).

## Start Middleman
```text
$ middleman server
```

## Create a post

```text
$ middleman article "Test Post"
```

## Editable code snippets

To add an editable code snippets to a page you need to use the render_code_component helper as per the example below.

Code should be a string which does not include double quotes (").

You can include this helper within a MD page as long as you add an `.erb` extension to the file. Example: `index.html.md.erb`.

```ruby
<%= render_code_component(
  heading: "Adding an on(:click) event to a BUTTON",
  code:
"class ExampleComponent < React::Component::Base
  render(DIV) do
    BUTTON { 'Push the button' }.on(:click) do
     alert 'you clicked'
    end
  end
end"
)%>
```

## Build and Publish to Github Pages
Published pages are in `master` branch.

Publishing to Github pages handled by [Middleman Github Pages gem](https://github.com/edgecase/middleman-gh-pages).

The rake tasks below will build and deploy to `master`

### Rake Tasks
```text
$ rake build    # Compile all files into the build directory
$ rake publish # Publish to master branch
```
**Note `rake publish` uses REMOTE_NAME=origin  BRANCH_NAME=master (see Rakefile)**
