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

## Build and Publish to Github Pages
Published pages are in `master` branch.

Publishing to Github pages handled by [Middleman Github Pages gem](https://github.com/edgecase/middleman-gh-pages).

The rake tasks below will build and deploy to `master`

### Rake Tasks
```text
$ rake build    # Compile all files into the build directory
$ rake publish # Publish to master branch
# rake publish REMOTE_NAME=reactrb BRANCH_NAME=master
```

**Important:** After each deploy you will have to reset the Custom Domain on the repro Settings to: `ruby-hyperloop.io`
