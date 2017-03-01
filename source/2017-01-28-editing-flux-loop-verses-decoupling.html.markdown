---
title: Editing Flux Loop verses Decoupling
date: 2017-01-28
tags:
---

@catmando

This started as some thoughts about when to use notation like

```ruby
AddItemToCart(item: sku, qty: 1) # Use an operation
# vs
Cart.addItem(item: sku, qty: 1) # Use a method on the Store
```

Which in thinking it through (the answer is 'always use the Operation', read on for details) led me to understand what I think is the real truth about the "flux loop."  And the answer to that is, it is nothing really to do with the "data flow" but with the coupling between parts of the system.

Actions (and Operations, Mutations, and to some extent decorators - maybe) provide a way to decouple elements of the system.

In the above example, why is the Operation better?  Sometime in the future, you may want to note that the current user showed interest in an SKU whenever that SKU gets added to the cart.  Where does this additional code go?  If you have gone down the path of directly calling `Cart.addItem` you have no place to logically add this code.  You can add it the Cart, but this now couples the Cart to some other model like UserInterests.  The two are pretty unrelated.  So you would end up moving the logic upwards and that puts it where it belonged in the first place: the AddItemToCart Operation.

Having Operations (which are basically the same as Actions + Action Creators + the Dispatcher) and using them *whenever data is mutated*  is a really good rule of thumb which is simple to understand, helps structure the code in a way that leaves it more maintainable, less brittle, and more reusable.

It also creates a "one-way data flow" but the problem is that I can create a system with one-way data flow that does not provide me with good decoupling between parts of the system.  I can also in perfectly good flux architecture still make dumb design decisions.

Here are three good things that having a central point like the Dispatcher or Operations solves:

1. **Decoupling Interface from Implementation**
  The flux Action paradigm decouples the Action protocol from the implementation completely.  An Action is a separate object from the Store receiving the action.  Some event handler calls the action, and the Store registers with the action.  In fact, you can have multiple Stores respond to the same Action.  Cool!

  But even without a Dispatcher you get all the biggest benefit which is the decoupling.  So I think its important to understand the first goal is to give a separate name to the Action (or Operation) and which can then be associated whatever Stores need to be updated.

2. **Debuggability***
  Running everything through the Action-Dispatcher (or an Operation base class) means that you can easily trace all actions/operations.  If you are using immutable data you can have even more fun.  This is good!

3. **Keeping Store Concerns Clean**
  Without some entity such as Actions to decouple Stores from *each other* you end up with Store A, knowing too much about Store B. So to emphasize the earlier example: we have a cart, we want to add an item.  Great.  But now you also want to update a "User Interest List" with any item a user has added to a cart.  So the naive implementation would probably have the Cart "add item" mechanism call some method on the UserInterestList Store.  Now the Cart which seems like the more "fundamental" class, is linked to the UserInterestList, and the spagetti begins to tangle.  

  This is a huge problem everywhere.  The "Action" solution is a simplified version of the TrailBlazer Operation, which itself is derived from the Mutation gem.  So the problem has been around for a while, and the solutions that work are similiar.

And here is and example of something Actions or Operations and having a central dispatcher does not solve:

**Bad class protocol design**  
We can describe how to "kill" a role playing character many ways.   

```ruby
Person.set_is_alive(id, boolean) # normal method call
{type: :set_is_alive, payload: {id: id, boolean: boolean}} # flux action
SetIsAlive(id, boolean) # Operation / Action Creator
# BAD! what if u change "alive-ness" to be a scale instead of yes/no?
Person.set_life_level(id, integer) # normal method call
{type: :set_life_level, payload: {id: id, level: level}} # flux action
SetLifeLevel(id, level) # Operation / Action Creator
# STILL BAD! Its less brittle but it still reveals too much implemenation
Person.kill(id)
{type: :kill, data: {id: id}}
Kill(id) # Operation / Action Creator
# This is a much better protocol!!!
```

  Regardless of whether I think of my system in terms of Classes and methods, actions, or operations, I can build good protocols or bad protocols.  Just declaring that I use "actions" to define my system does not solve this problem.  People must realize that "Actions" are just another way to describe messages to move data between elements of the system.  Just changing terminology from methods, classes or procedure calls to 'Actions' and 'Stores' solves nothing.

So there are three good reasons to use an architecture that centralizes the mutation of stores to a single point (or a single class) plus one thing such an architecture does not solve.  **But note:  No place in that discussion did we say anything about one-way data flow.**  That is a side effect and frankly a distraction I think.  There are going to be times where its best to violate the "one-way data flow" but that does not mean you have to in any way give up good design principles.

I think its much easier and clearer to think in terms of who mutates the stores.  Providing an answer like "in general it should be the Operations", is a good starting point to discovering the best way to decouple the system.  I don't think saying "make the data flow one way" is as helpful.

#### How is this going to work in Hyperloop

Here is the basic approach:

```ruby
class AddItemToCart < HyperOperation
  param :sku
  param qty: 1
end

class Cart < HyperStore
  state_reader items: Hash.new { |h, k| h[k] = 0 }, scope: :class

  receives AddItemToCart, scope: :class do
    state.items![params.sku] += params.qty
  end
end
```

  (+) Nice and easy  
  (-) Adds (maybe) 2 lines to every mutator (`class ... end`)  
  (+) Allows for other stores to participate in the Operation   
  (+) Clearly corresponds to the Flux model (i.e. Operation == Action + Action Creator + Dispatcher)  

### Improving on the above

In many cases there is a "default" association between the Operation and the Store.  You can see this in the names `Cart` and `AddItemToCart`. This is very common in real world examples.  Given this it makes sense to namespace the actions with the store:

```ruby
class Cart < HyperStore
  class AddItem < HyperOperation
    param :sku
    param qty: 1
  end
  state_reader items: Hash.new { |h, k| h[k] = 0 }, scope: :class
  receives AddItem, scope: :class do
    ...
  end

end
```

We have not changed much, but things look much logical.  You would say:

```ruby
  Cart.items # works just like a scope
  Cart::AddItem(...)  # stands out!!! must be a mutator
```

You can still have other unrelated Stores receive AddItem:

```ruby
class UserInterestList < HyperStore
  receives Cart::AddItem, scope: :class do
    ...
  end
end
```

And because we know that Cart is by default related to AddItem, we can make sure that Cart always receives AddItem first, thus doing away with a common reason for needing to explicitly specify the order that Stores should receive an action.

If it's not obvious which class the Operation belongs (you can probably see it right in the name) to then it really is its own thing and should be placed in its own namespace.  So for example:
```ruby
class ResetToDefaults < HyperOperation
end
```
Clearly there is no associated Store, so ResetToDefaults stands alone.

While it's a little more typing (2 lines) you now can give a robust specification to the parameters coming into the Operation.  This seems important if the rule of thumb is that Operations are controlling mutations of our Stores

```ruby   
class Cart < HyperStore  
  class AddItem < HyperOperation
    param :sku, type: String, matches: SKU_PATTERN    
    param qty: 1, type: Numeric, minimum: 1
  end   
  ...
end
  ```  

Finally note that nesting the declaration of the Operation inside a Store, does not prevent you from adding special logic not related to the Store elsewhere:

```ruby
# some where else in the code:
class Cart::AddItem < HyperOperation
  def execute
    ConfirmItemAvailability(sku: sku).then { super }
  end
end
```

Other questions:

+ **Can Stores Invoke Operations**
  In general no.  Stores should be kept as simple as possible.  If possible move invocation of the Operation upwards into another Operation's execute method.  The obvious exception would be if the Store is providing a stream of data from an asynchronous source.  In this case, a Store's 'getter' is going to detect the Data has run out, and can invoke an Operation to get more.  The Operation will be asynchronous and when it resolves can inform the Store that it can update its state with new data.  The way Operations, states, and promises work together make this straight forward to do.

+ **Can Operations Read From Stores**
  Yes.  Often an Operation will read from one Store to determine if it should update another store.  

+ **Can Operations Invoke Other Operations**
  Yes.  Note that Operations return promises, so asynchronous operation is assumed, Operations can be easily chained.
