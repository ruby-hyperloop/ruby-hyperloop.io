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

## Live edit code snippets

To add lived edit code snippets to a page simply put the code in a `<pre>` block within a `<div class="codemirror-live-edit">` as per the example below. Note that you can also optionally pass a heading.

To a add this to a Markdown (.md) file you need to add an .erb extension to the file: `index.html.md.erb`.

All components need to be called `ExampleComponent` (hopefully this will be improved sometime soon).

`data-heading` and `data-rows` are optional.

```ruby
<div class="codemirror-live-edit"
  data-heading="A simple Component rendering a Button">
  data-rows=10>
<pre>
class ExampleComponent < Hyperloop::Component
  render(DIV) do
    BUTTON { 'Push the button' }.on(:click) do
     alert 'you clicked'
    end
  end
end
</pre></div>
```

## Build and Publish to Github Pages
Published pages are in `master` branch.

Publishing to Github pages handled by [Middleman Github Pages gem](https://github.com/edgecase/middleman-gh-pages).

The rake tasks below will build and deploy to `master`

### Rake Tasks
```text
$ rake update   # Clones all hyperloop repos and copies README.md files to website folders
$ rake build    # Compile all files into the build directory
$ rake publish  # Publish to master branch
```
**Note `rake publish` uses REMOTE_NAME=origin  BRANCH_NAME=master (see Rakefile)**
