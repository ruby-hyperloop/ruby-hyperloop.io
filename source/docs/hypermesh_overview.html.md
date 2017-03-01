---
title: Models
---
## Models Overview

Hyperloop **Models** are implemented in the **HyperMesh Gem**.

HyperMesh takes Isomorphic Ruby to the next level by giving your HyperReact components CRUD access to your server side ActiveRecord models, using the standard ActiveRecord API. In addition, HyperMesh implements push notifications (via a number of possible technologies) so that changes to records on the server are dynamically pushed to all authorised clients.

**Its Isomorphic Ruby in action.**

In other words one browser creates, updates, or destroys a model, and the changes are persisted in active record models, before being broadcast to all other authorised clients.

Overview:

+ HyperMesh is built on top of HyperReact.
+ HyperReact is a Ruby DSL (Domain Specific Language) to build [React.js](https://facebook.github.io/react/) UI components in Ruby.  As data changes on the client (either from user interactions or external events) HyperReact re-draws whatever parts of the display is needed.
+ HyperMesh provides a [flux dispatcher and data store](https://facebook.github.io/flux/docs/overview.html) backed by [Rails Active Record models](http://guides.rubyonrails.org/active_record_basics.html).  
You access your model data in your HyperReact components just like you would on the server or in an ERB or HAML view file.
+ If an optional push transport is connected, HyperMesh broadcasts any changes made to your ActiveRecord models as they are persisted on the server.

For example, consider a simple model called `Dictionary`, which might be part of Wiktionary type app.

```ruby
class Dictionary < ActiveRecord::Base

  # attributes
  #   word: string   
  #   definition: text
  #   pronunciation: string

  scope :defined, -> { 'definition IS NOT NULL AND pronunciation IS NOT NULL' }
end
```

Here is a very simple HyperReact component that shows a random word from the dictionary:

```ruby
class WordOfTheDay < React::Component::Base

  def pick_entry!  
    # pick a random word and assign the selected record to entry
    @entry = Dictionary.defined.all[rand(Dictionary.defined.count)]
    force_update! # redraw our component when the word changes
    # Notice that we use standard ActiveRecord constructs to select our
    # random entry value
  end

  # pick an initial entry before we mount our component...
  before_mount :pick_entry

  # Again in our render block we use the standard ActiveRecord API, such
  # as the 'defined' scope, and the 'word', 'pronunciation', and
  # 'definition' attribute getters.  
  render(DIV) do
    DIV { "total definitions: #{Dictionary.defined.count}" }
    DIV do
      DIV { @entry.word }
      DIV { @entry.pronunciation }
      DIV { @entry.definition }
      BUTTON { 'pick another' }.on(:click) { pick_entry! }
    end
  end
end
```
