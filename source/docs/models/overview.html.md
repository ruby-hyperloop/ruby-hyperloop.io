---
title: Models
---
## Models Overview

Hyperloop **Models** are implemented in the **HyperMesh Gem**.

In Hyperloop, your ActiveRecord Models are available in your Isomorphic code.

Components, Operations, and Stores have CRUD access to your server side ActiveRecord Models, using the standard ActiveRecord API.

In addition, Hyperloop implements push notifications (via a number of possible technologies) so changes to records on the server are dynamically pushed to all authorized clients.

*Isomorphic Ruby in action.*

In other words, one browser creates, updates, or destroys a Model, and the changes are persisted in ActiveRecord models and then broadcast to all other authorized clients.

## Overview

+ The `hyper-model` gem provides ActiveRecord Models to Hyperloop's Isomorphic architecture.
+ You access your Model data in your Components, Operations, and Stores just like you would on the server or in an ERB or HAML view file.
+ If an optional push transport is connected Hyperloop broadcasts any changes made to your ActiveRecord models as they are persisted on the server or updated by one of the authorized clients.
+ Some Models can be designated as *server-only* which means they are not available to the Isomorphic code.

For example, consider a simple model called `Dictionary` which might be part of Wiktionary type app.

```ruby
class Dictionary < ActiveRecord::Base

  # attributes
  #   word: string   
  #   definition: text
  #   pronunciation: string

  scope :defined, -> { 'definition IS NOT NULL AND pronunciation IS NOT NULL' }
end
```

Here is a very simple Hyperloop Component that shows a random word from the dictionary:

```ruby
class WordOfTheDay < Hyperloop::Component

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
```

For complete examples with *push* updates, see any of the apps in the `examples` directory, or build your own in 5 minutes following one of the quickstart guides:
