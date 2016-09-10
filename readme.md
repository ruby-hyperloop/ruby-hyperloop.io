# Reactrb.org Static Website

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
Published pages are in `gh-pages` branch. Publishing to Github pages handled by [Middleman Github Pages Gem](https://github.com/edgecase/middleman-gh-pages)

### Rake Tasks
```text
$ rake build    # Compile all files into the build directory
$ rake publish  # Build and publish to Github Pages
```
