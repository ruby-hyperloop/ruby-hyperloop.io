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

## Layouts

There are two layouts used in this site: `source/layout` and `source/layouts/layout_with_toc`. Most pages use the default layout and do not need any special consideration. Pages with an automatic Table Of Content (TOC) should use the 2nd layout (which need to be specified in `config.rb`). The TOC generator is set to only generatea TOC for h1 tags.

**Any stylistic changes must be made to both layouts.**

## Build and Publish to Github Pages
Published pages are in `gh-pages` branch. Publishing to Github pages handled by [Middleman Github Pages Gem](https://github.com/edgecase/middleman-gh-pages).

**The following rake tasks will not run with uncommited changes.**

### Rake Tasks
```text
$ rake build    # Compile all files into the build directory
$ rake publish  # Build and publish to Github Pages
```
