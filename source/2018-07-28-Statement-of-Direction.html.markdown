---
title: Statement of Direction
date: 2018-07-28 08:47 UTC
tags:
---

We thought it would be useful to put a stake in the ground down for the project and also propose a few fundamental changes which have been in discussion in the background for some time but not decided on, which has caused some confusion and indeed a lack of clarity.

### 1.0 release goals

+ Webpack based build process (take advantage of the very best Webpack features including tree shaking, lazy loading, etc). Yarn and Webpack will be our build setup, recomendation and tutorials.
+ Remove dependency on sprockets and dependencies on gems that depend on sprockets
+ Remove dependency on Rails and React-rails gem
+ Create Install generators for Rails, Rack, Roda (our baseline installation will be Rack, with added configuration for Rails, Roda and other Rack-based frameworks)
+ Pre-rendering for Rack (and all Rack-based projects)
+ HyperReact and HyperComponent merge into one codebase
+ HyperMesh and HyperResource co-exist but to merge over time
+ Use Redis instead of AR for pub-sub if it is available
+ New website, new positioning, correct docs, tutorials and installation

We also re-affirmed our core principles.

### Core principles

+ Developer productivity as highest goal - creativity and productivity go together
+ Single language - which leads to 'whole application' thinking
+ Convention over configuration
+ DRY APIs - no layer repetition
+ React based client-side DSL
+ Fun and pure joy to work with

### Name change: Ruby-Hyperloop.org to Hyperstack.org

We all like the Hyperloop name, and if we could we would continue to use just Hyperloop, but without the ruby prefix Hyperloop is lost. Hearin is the paradox. As much as we are focused on one language (ruby) today, we also believe we most likely to embrace more than one language in the future. Crystal looms large for us. Therefore, being tethered to a ruby prefix is just stacking up problems for the future where the cost of change is higher. We also do not want any radical changes after our 1.0 release milestone as this milestone is to indicate the stability and steadfastness of the project.

We, therefore, think it is better to bite the bullet and rename the project at this stage. We have acquired the hyperstack.org domain and secured hyperstack-org as a project name on Github.

We plan to leave the ruby-hyperloop.org website in place with a banner explanation, redirecting visitors to the new hyperstack.org website. Our 1.0 documentation, new tutorials and new positioning will all be published on the new website only.

This will be the 2nd rename this project has gone through (previously we were reactrb.org) so let's hope it is the last.

What remains to be said is to thank you all for your participation and collaboration in this community. Let's build something special together.
