---
title: Hyperloop is born
date: 2016-09-08 05:50 UTC
tags:
---

Reactrb is being renamed Ruby Hyperloop to reflect the change in emphasis of the project. We have chosen Hyperloop as an umbrella name for the project as it is more expansive and allows us to build out Hyperloop as a web application framework.

React and Reactrb (being renamed HyperReact) remain fundamental parts of this project.

## Gems

All of the Hyperloop core gems will take on a Hyper-name. The naming convention will be HyperReact when discussion the gem and the actual gem will be `hyper-rect`. All of the gems will follow this convention.

+ Reactrb becomes **HyperReact**
+ Reactrb Router becomes **HyperRouter**
+ Reactive Record and Synchromesh will be merged to become one gem, **HyperMesh**
+ Reactrb Rails Generator becomes **HyperRails**
+ Reactrb Express becomes **Hyperloop Express**

## Website

+ Reactrb.org is changing to **ruby-hyperloop.io**
+ The goal of this refactor is to reposition Reactrb as an umbrella project for Reactrb and associated Isomorphic ruby technologies
+ The emphasis of the site will be to show how simple Reactrb is to use and also to show best practice for taking it further (Stores, etc). There will be a few tutorials.
+ The new Reactrb.org will not try to mirroring the React(JS) site – but will have its own identity and structure but it will use as much of the existing Reactrb content as possible
+ Remove all the original React(JS) text and structure (basically remove everything that comes from the original React site and does not pertain to Reactrb)
+ New fresh looking design
+ The new site documentation will include Architectural and + Pattern discussions, describing best practice when working with React like components and stores
+ There will be a section on Reactrb development tools (Opal Console) and techniques
+ All of the above Gem’s documentation should be on reactrb.org. The individual Gem’s Read-me’s should be minimal and refer to each Gem’s page on reactrb.org so we can emphasize that these gems are a part of the same family and explain how they work together include installation, usage and best practice instructions for use with:
  + Rails
  + Sinatra
  + Webpack & NPM
+ Will still include Live Ruby examples through Opal Playground
+ The site will continue to be hosted on Github pages but the underlying technology will change to:
  + Reactrb Express
  + Middleman

The changes will be made over time so some Gems, Docs and Tutorials might reference Reactrb or their previous names.
