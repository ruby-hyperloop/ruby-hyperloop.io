# Reactrb.org

This static site is built with Middleman.

## Start Middleman
```text
$ middleman server
```

## Create a post

```text
$ middleman article "Test Post"
```

## Build and Publish
Published pages are in `gh-pages` branch.
```text
$ rake build    # Compile all files into the build directory
$ rake publish  # Build and publish to Github Pages
```
