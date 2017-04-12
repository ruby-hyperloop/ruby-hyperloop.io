---
title: Spring 2017 COMPS Release
date: 2017-02-28
tags:
---

Spring 2017 heralds a major Hyperloop release. This release will be the first where we have introduced the 5 architectural constructs focused on making it easier to write Isomorphic applications.

This release includes a new version and renaming of all of the Hyperloop gems as well as several new concepts and gems.

These release notes cover the following topics:

+ [Release Overview](#release-overview)
+ [Gem changes](#gem-changes)
+ [New folder layout](#new-folder-layout)
+ [Base class names](#base-class-names)

## Release Overview

This release consists of:

+ Introduction of COMPS (Components, Operations, Models, Policies and Stores) architectural concepts
+ Introduction of Hyper-Operation gem
+ Introduction of Hyper-Store gem
+ Introduction of Hyper-Spec gem
+ Introduction of a centralized Hyperloop configuration gem
+ Renaming of HyperMesh gem to Hyper-Model
+ Renaming of Express gem to Hyperloop-JS
+ Changes to state syntax from bang(!) notation to mutate method
+ Changes to all base class names (Hyperloop::Component, Hyperloop::Model, etc) for consistency
+ Changes to the location of files in a Rails project
+ New Hyperloop JS based on latest gems
+ New HyperRails gem
+ New website documentation, lived-code editing, new styling and new branding

## Gem changes

#### Version Numbers and Content
| gem | version | notes |
|-----------------|---------|-------|
| hyper-loop | 0.8 | initial release |
| hyper-store | 0.2.2 | initial release |
| hyper-operation | 0.5.4 | initial release |
| hyper-component | 0.12.5 | latest hyper-react + pending fixes + compatibility `requires` (see below) |
| hyper-model | 0.6.0 | hyper-mesh 0.5.x + fixes + dependence on hyper-store and hyper-operation gems |
| hyperloop-js | 0.1 | latest gems + decoupling of Hyperloop and Opal |

#### Hyper-Component compatibility
The hyper-component gem will include 3 compatibility modes, determined by which file you require in `components.rb.`

+ **Hyperloop Standard**: (`require 'hyper-component'`) In this mode you will use the new hyperloop syntax for all names, macros etc.  I.e. components are defined as subclasses of `Hyperloop::Component` or using `Hyperloop::Component::Mixin`.   States are changed using the `mutate` objectrather than the exclamation notation.  States are declared using the `state` macro.
+ **HyperReact Compatibility**: (`require 'hyper-react'`) In this mode you can use either syntax, but you will get deprecation warnings, as this mode *will* go away.  This mode will be provided as a bridge so developers can use Operations and Stores without having to make changes to existing components.
+ **DSL Only** (`require 'hyper-react-dsl'`)  In this mode you will use the new syntax, however, the DSL will be limited to the base feature set provided by react.js.  This mainly applies to states acting as stores.  The advantage will be smaller payload size.  Initially, this mode not exist but the code will be set up to support it easily in the future

In addition, we will make one more release to the hyper-react and hyper-mesh gems that simply provides the hyper-component and hyper-model functionality, plus a deprecation warning.  The intent is that the next time you update these gems, you will get the warning, and will know to change to the new gem names.

#### Store and Operation interoperability

Stores depend on `Hyperloop::Application::Boot`, which is an operation defined in the Operation gem.  So that you can use stores without operations, the store gem will define a very basic boot operation *unless* Hyperloop::Application::Boot is already defined.

#### Hyperloop.JS

Hyperloop.JS now supports Compoennts, Operations and Stores.

There is no gem here, just JavaScript files.  We will have two: hyperloop.js which includes Components, Operations and Stores and opal-compiler.js which includes Opal and Opal Compiler.

## New folder layout

There is a folder layout within a Rails project.

Old folder layout:

```text
/app/views/components          <-- HyperReact components
/app/models/public             <-- HyperMesh models
/app/models                    <-- server-only models
/app/views/components.rb       <-- component manifest
/app/policies                  <-- HyperMesh policies
```

New folder layout:

```text
/app/hyperloop/components      <-- components
/app/hyperloop/models          <-- isomorphic models
/app/models                    <-- server-only models
/app/hyperloop/operations      <-- isomorphic operations
/app/operations                <-- server-only operations
/app/hyperloop/stores          <-- stores
/app/hyperloop/hyperloop.rb    <-- hyperloop manifest
/app/policies                  <-- policies
```

## Base classes and Mixins

Hyperloop base classes follow a consistent naming convention:

+ `Hyperloop::Operation`
+ `Hyperloop::Store`
+ `Hyperloop::Policy`

You can inherit from the class:

```ruby
class Cart < Hyperloop::Store
  ...
end
```

Or mixin the module:

```ruby
class Cart
  include Hyperloop::Store::Mixin
  ...
end
```

Mixins available:

+ `Hyperloop::Store::Mixin`
+ `Hyperloop::Policy::Mixin`
