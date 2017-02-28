---
title: Spring 2017 COMPS Release
date: 2017-02-28
tags:
---

# Spring 2017 COMPS Release

TODO: Change data of this article to actual release date

Spring 2017 heralds a major Hyperloop release. This release will be the first where we have introduced the 5 architectural constructs focused on making it easier to write Isomorphic applications.

This release includes a new version and renaming of all of the Hyperloop gems as well as several new concepts and gems.

These release notes cover the following topics:

+ [Release Overview](#release-overview)
+ [Gem dependancy and naming changes](#gem-dependancy-and-naming-changes)
+ [New folder layout in Rails project](#new-folder-layout-in-rails-project)
+ [Base class names](#base-class-names)

## Release Overview

This release consists of:

+ Introduction of COMPS (Components, Operations, Models, Policies and Stores) architectural concepts
+ Introduction of Hyper-Operation gem
+ Introduction of Hyper-Store gem
+ Introduction of Hyper-Spec gem
+ Introduction of Hyperloop-config gem (TODO: is this happening?)
+ Renaming of HyperReact gem to Hyper-Component
+ Renaming of HyperMesh gem to Hyper-Model
+ Changes to state syntax from bang(!) notation to mutate method
+ Changes to all base class names (Hyperloop::Component, Hyperloop::Model, etc) for consistency
+ Changes to the location of files in Rails project
+ New Hyperloop Express based on latest gems
+ New HyperRails gem
+ New website documentation, lived-code editing, new styling and new branding

## Gem dependancy and naming changes

TODO: change tense from future to past tense in this section

This describes how we get from the current mixed bag of HyperReact/Mesh gems to a consistent set of Hyperloop gems (and hyperloop-express js files.)

First the gem file dependencies:

```text

  hyperloop-config
   ^            ^
   |            |
   |            |--------hyper-store
   |                         ^    ^              
   |                         |    |--hyper-component
   |                         |
   |                         |
   |--hyper-operation        |
   |         ^               |
   |         |               |
   |         |--hyper-model--|
   |
   |--hyper-rails (might use hyperloop config for control?)
```

###Notes

#### hyperloop-config gem
This just provides a standard way for the other gems to define config params that can be stored in a rails style initializer.  It is never needed to be directly referenced in a Gemfile or `require` by the developer.

#### Version Numbers and Content
| gem | version | notes |
|-----------------|---------|-------|
| hyper-loop | 0.8 | initial release |
| hyper-store | 0.8 | initial release |
| hyper-operation | 0.8 | initial release |
| hyper-component | 0.12 | hyper-react 0.11 + pending fixes + compatibility `requires` (see below) |
| hyper-model | 0.6 | hyper-mesh 0.5.x + fixes + dependence on hyper-store and hyper-operation gems |

#### Hyper-Component compatibility
The hyper-component gem will include 3 compatibility modes, determined by which file you require in `components.rb.`
* **Hyperloop Standard**: (`require 'hyper-component'`) In this mode you will use the new hyperloop syntax for all names, macros etc.  I.e. components are defined as subclasses of `Hyperloop::Component` or using `Hyperloop::Component::Mixin`.   states are changed using `mutate` rather than the exclamation notation.
* **HyperReact Compatibility**: (`require 'hyper-react'`) In this mode you can use either syntax, but you will get deprecation warnings, as this mode *will* go away.  This mode will be provided as a bridge so developers can use Operations and Stores without having to make changes to existing components.
* **DSL Only** (`require 'hyper-react-dsl'`)  In this mode you will use the new syntax, however, the DSL will be limited to the base feature set provided by react.js.  This mainly applies to states acting as stores.  The advantage will be smaller payload size.  Initially, this mode not exist but the code will be set up to support it easily in the future

In addition, we will make one more release to the hyper-react and hyper-mesh gems that simply pulls in provides the hyper-component and hyper-model functionality, plus a deprecation warning.  The intent is that the next time you update these gems, you will get the warning, and will know to change to the new gem names.

#### Store and Operation interoperability

Stores depend on `Hyperloop::Application::Boot`, which is an operation defined in the Operation gem.  So that you can use stores without operations, the store gem will define a very basic boot operation *unless* Hyperloop::Application::Boot is already defined.

#### Hyperloop Express

There is no gem here, just JS files.  We will have two: hyperloop-express.js which includes hyper-component (and therefore hyper-store) and hyperloop-express-operation.js which brings in the `Hyperloop::Operation` class (but not the `Hyperloop::ServerOp` class)

To support this the `hyper-operation` gem will have a `hyper-operation/client_only` require file.

## New folder layout in Rails project

There is a folder layout within a Rails project.

Old folder layout:

```text
/app/views/components          <-- HyperReact components
/app/models/public             <-- HyperMesh models
/app/policies                  <-- HyperMesh policies
/app/views/components.rb       <-- Opal requires
```

New folder layout:

```text
/app/hyperloop/components      <-- components
/app/hyperloop/operations      <-- operations
/app/hyperloop/models          <-- models
/app/policies                  <-- policies
/app/hyperloop/stores          <-- stores
/app/hyperloop/hyperloop.rb    <-- Opal requires
```

## Base class names

For consistency, `React::Component::Base` as been changed to `Hyperloop::Component`

All Components now inherit from `Hyperloop::Component`:

```ruby
class Clock < Hyperloop::Component
  ...
end
```

Or you may also create a component class by mixing in the Hyperloop::Component module:

```ruby
class Clock
  include Hyperloop::Component
  ...
end
```

### Base classes:

+ Hyperloop::Component
+ Hyperloop::Operation
+ Hyperloop::Model
+ Hyperloop::Policy (TODO: is this true?)
+ Hyperloop::Store
